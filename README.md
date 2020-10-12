# Dockerized Nomad
This repo produces a dockerized version of Nomad. This is a fork of the project [djenriquez/nomad](https://www.github.com/djenriquez/nomad).

This image is meant to be run with host network privileges. It can use preconfigured Nomad hcl files by mounting those config to `/etc/nomad`.

# To run:

```bash
docker run -d \
--name nomad \
--net=host \
-v "/opt/nomad:/opt/nomad" \
-v "/etc/nomad.d:/etc/nomad.d" \
-v "/var/run/docker.sock:/var/run/docker.sock" \
-v "/tmp:/tmp" \
zukunftverstehen/nomad:latest agent
```

The above command is identical to running this example in Nomad's documentation for [bootstrapping with Consul](https://www.nomadproject.io/docs/cluster/bootstrapping.html).

# Correctly configuring Nomad data directory

Due to the way Nomad exposed template files it generates, you need to take
special precautions when configuring its data directory.

In case you are running Docker containers and using the ``template`` stanza,
the Nomad ``data_dir`` has to be configured with the **exact same path as the
host path**, so the host Docker daemon mounts the correct paths, as exported by
the Nomad client, into the scheduled Docker containers.

You can run the Nomad container with the following options in this case:

```bash
export NOMAD_DATA_DIR=/host/path/to/nomad/data

docker run \
...\
-v $NOMAD_DATA_DIR:$NOMAD_DATA_DIR:rw \
-e NOMAD_DATA_DIR=$NOMAD_DATA_DIR \
zukunftverstehen/nomad:latest agent
```

