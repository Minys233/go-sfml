#! /bin/bash
VER="2.6.1"
DST="/Users/yaosenmin/workspace"

download_src() {
    versions=$(curl -s https://api.github.com/repos/SFML/$1/releases | jq '.[].tag_name' | tr -d '"')
    echo "Available versions:"
    echo "$versions"
    saved_IFS=$IFS
    while IFS= read -r ver ; do 
        if [ "$ver" = "$VER" ]; then
            wget -O $DST/$ver.zip "https://github.com/SFML/$1/archive/$ver.zip"
            unzip $DST/$ver.zip -d $DST
        fi
    done <<< "$versions"
    
    IFS=$saved_IFS
    unset saved_IFS
}

# 1. download SFML relase
if [ ! -d $DST/SFML-$VER ]; then
    download_src SFML
fi
SFML_BASE=$(readlink -f $DST/SFML-$VER)
SFML_INSTALL=$SFML_BASE/build
echo $SFML_BASE
# 2. build SFML
SFML_CMAKE_OPTIONS=(
    -DBUILD_SHARED_LIBS=TRUE
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=$SFML_INSTALL
    -DSFML_BUILD_AUDIO=TRUE
    -DSFML_BUILD_GRAPHICS=TRUE
    -DSFML_BUILD_NETWORK=TRUE
    -DSFML_BUILD_WINDOW=TRUE
    -DSFML_BUILD_DOC=FALSE
    -DSFML_BUILD_EXAMPLES=FALSE
    -DSFML_BUILD_FRAMEWORKS=FALSE
    -DSFML_BUILD_TEST_SUITE=FALSE
    -DSFML_USE_SYSTEM_DEPS=FALSE
)

current_dir=$(pwd)
cd $SFML_BASE
echo "Building SFML..."
echo $(pwd)
echo "cmake $SFML_CMAKE_OPTIONS ."
# cmake $SFML_CMAKE_OPTIONS .
cmake "${SFML_CMAKE_OPTIONS[@]}" .
make -j8 all
make install
cd $current_dir


#3. build CSFML
if [ ! -d $DST/CSFML-$VER ]; then
    download_src CSFML
fi
CSFML_BASE=$(readlink -f $DST/CSFML-$VER)
CSFML_INSTALL=$CSFML_BASE/build
CSFML="CSFML"

CSFML_CMAKE_OPTIONS=(
    -DBUILD_SHARED_LIBS=TRUE
    -DCMAKE_INSTALL_PREFIX=$CSFML_INSTALL
    -DCSFML_BUILD_AUDIO=TRUE
    -DCSFML_BUILD_GRAPHICS=TRUE
    -DCSFML_BUILD_NETWORK=TRUE
    -DCSFML_BUILD_WINDOW=TRUE
    -DCSFML_BUILD_DOC=FALSE
    -DCSFML_LINK_SFML_STATICALLY=FALSE
)

current_dir=$(pwd)
cd $CSFML_BASE
echo "Building CSFML..."
echo $(pwd)
echo "SFML_DIR=$SFML_BASE/build cmake $CSFML_CMAKE_OPTIONS ."
# cmake $SFML_CMAKE_OPTIONS .
SFML_DIR=$SFML_BASE/build cmake "${CSFML_CMAKE_OPTIONS[@]}" .
make -j8 all
make install
cd $current_dir

# 4. Run swig and build
SFML_MODULES=(Audio Graphics System Window)

for Module in "${SFML_MODULES[@]}"; do
	module=$(echo $Module | tr '[:upper:]' '[:lower:]')
    echo $Module-$module
    swig -go -cgo -c++ -intgosize 64 -cpperraswarn "-I$CSFML_INSTALL/include" ./interfaces/${Module}.i
    mv ./interfaces/${module}.go ./interfaces/${Module}_wrap.cxx ./${module}/
    GO111MODULE=off CGO_LDFLAGS="-L$CSFML_INSTALL/lib -lcsfml-$module" CGO_CXXFLAGS="-I$CSFML_INSTALL/include" go install "./$module"
    # exit 0
done




# export CGO_CFLAGS="-I$CSFML_PATH/include"
# export CGO_CPPFLAGS="-I$CSFML_PATH/include"
# export CGO_CXXFLAGS="-I$CSFML_INSTALL/include"
# export CGO_LDFLAGS="-L$CSFML_INSTALL/lib"


# CGO_CXXFLAGS="-I$CSFML_INSTALL/include" CGO_LDFLAGS="-L$CSFML_INSTALL/lib -Wl,-rpath,/Users/yaosenmin/workspace/CSFML-2.6.1/build/lib -Wl,-rpath,/Users/yaosenmin/workspace/SFML-2.6.1/build/lib -lcsfml-audio -lcsfml-graphics -lcsfml-system -lcsfml-window" go run .