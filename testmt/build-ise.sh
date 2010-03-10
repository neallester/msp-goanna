#!/bin/bash

echo "Removing EIFGEN directory..."
rm -rf EIFGEN
echo "Compiling Eiffel..."
ec -batch -finalize -keep 
echo "Compiling C..."
( cd EIFGEN/F_code; finish_freezing -stop )
cp EIFGEN/F_code/*.exe .