## Vulnerable nodejs app for demos

**WARNING**: *This app deliberately exposes a RCE vulnerability (CVE-2013-4660). It is meant to demonstrate the use of Docker to clean up after a breach and prevent them from happening again in the future.*

#### Build & run:

    $ docker build -t node-hack .
    $ docker run -it --rm -p 1337:1337 --name example-app example-app

#### Browse to and demo app:

    $ open http://0.0.0.0:1337

- Upload `yaml/nice.yml`, `yaml/broken.yml` and `yaml/evil.yml` for demonstration.
- Browse to start page to see defaced website.
- `Ctrl+c` & re-run container to show the breach casued by `evil.yml` is gone again.
