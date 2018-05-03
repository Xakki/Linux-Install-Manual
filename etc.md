

find ./ -type f -name '*.php' -exec sed -i -e 's/\r//g' {} \;
