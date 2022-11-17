#! /bin/bash

OUTPUT=./output

rm -rf $OUTPUT && mkdir ${OUTPUT}

helm package ./helm/growbe-cloud -d $OUTPUT && helm package ./helm/growbe-cloud-secrets -d $OUTPUT
helm repo index ./output/