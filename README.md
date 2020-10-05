# Usage

To be executed on DemoCCC: https://external-csp-access.cloud.worldline.com/aws/roles/SysAdmin@demo-cccnoprd


```
curl -O https://gitlab.kazan.priv.atos.fr/ccc/sources/photobooth/uploads/09be7c9e06b0470dfdf84dfe4ea7919c/photobooth.tar.gz
tar xvzf photobooth.tar.gz
cd photobooth
export AWS_DEFAULT_REGION=eu-west-3
export AWS_BUCKET=test-rpt-2
./photobooth
```

