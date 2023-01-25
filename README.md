# dev-k8s-cluster-base

This project contains the configuration of some base applications/components of
a Kubernetes cluster used for local development. The setup is deployed and
managed with [Helmfile](https://github.com/helmfile/helmfile).

The setup includes:

- **Custom certificate management:**\
  Installs [cert-manager](https://cert-manager.io/) to manage certificates, including
  setting up a custom certificate authority (CA) with a self-signed CA certificate.
- **Reverse proxy with SSL:**\
  Installs and configures [traefik](https://traefik.io/traefik/) as the primary reverse
  proxy for the cluster. A custom wildcard certificate for the configured apex domain
  is provisioned and used as the default certificate for all subdomains used in the
  HTTP routes.
