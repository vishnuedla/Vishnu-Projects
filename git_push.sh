#!/bin/bash

read -p "Enter your commit message: " modified

git add .


git commit -m "$modified"


git push origin main

echo "Sucessfully push the changes to main branch"
