#!/bin/bash
set -e

fdw_name=$1
if [[ -z $fdw_name ]]; 
then
    echo "FDW name is not specified. Exiting..."
    exit 1
fi

major_version=$2
if [[ -z $major_version ]]; 
then
    major_version=$(yq '.default_version' config.yml)
    echo "Postgres version is not specified. Using ${major_version} as default"
fi

base_version=$(yq ".${major_version}.pg_base" config.yml)
if [[ $base_version == "null" || -z $base_version ]]; 
then
    echo "Postgres base image version is not initialized."
    echo "Check your inputs against config.yml file. Exiting..."
    exit 1
fi

fdw_version=$(yq ".${major_version}.fdw.${fdw_name}" config.yml)
if [[ $fdw_version == "null" || -z $fdw_version ]]; 
then
    echo "\"${fdw_name}\" fdw version is not initialized."
    echo "Check your inputs against config.yml file. Exiting..."
    exit 1
else
    if [[ $fdw_version =~ ^https?:// ]]; 
    then
        echo "Using custom URL for ${fdw_name} extension"
        fdw_url=$fdw_version
        fdw_version=""
    else
        fdw_url=""
    fi
fi


echo
echo Postgres major version: ${major_version}
echo Postgres base image: $base_version
echo FDW name: $fdw_name
echo FDW version: $fdw_version
echo FDW url: $fdw_url

echo 
echo "Building image for ${fdw_name} extension..."
if [[ -z $fdw_url ]]; 
then
    echo "Using released ${fdw_version} version for ${fdw_name} extension"
    docker build \
        --build-arg base_tag=$base_version \
        --build-arg pg_version=$major_version \
        --build-arg fdw_version=$fdw_version \
        -t chumaky/postgres_${fdw_name}_fdw:${base_version}_fdw${fdw_version} \
        -f postgres_${fdw_name}.docker \
        . 
else
    echo "Using source url for ${fdw_name} extension"
    docker build \
        --build-arg base_tag=$base_version \
        --build-arg pg_version=$major_version \
        --build-arg fdw_url=$fdw_url \
        -t chumaky/postgres_${fdw_name}_fdw:${base_version}_fdw${fdw_version} \
        -f postgres_${fdw_name}.docker \
        .
fi