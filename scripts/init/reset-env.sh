#!/bin/bash

echo "--- Resetting .env from .env.template"
rm -rfv .env
cp -v .env.template .env