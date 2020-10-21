#!/usr/bin/env bash

cd admin_template_core
echo $(pwd)
pub upgrade
cd ..

cd admin_template_generator
echo $(pwd)
pub upgrade
cd ..

cd example
echo $(pwd)
flutter pub upgrade
cd ..

cd admin_template
echo $(pwd)
flutter pub upgrade
cd ..
