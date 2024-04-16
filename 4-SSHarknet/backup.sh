#!/bin/bash

curl http://localhost:8080
curl http://localhost:8080/key
curl http://localhost:8080/?key=key
curl -u data:asdf http://localhost:8080
curl -u data:asdf http://localhost:8080/key
curl -u data:asdf http://localhost:8080/?key=key
