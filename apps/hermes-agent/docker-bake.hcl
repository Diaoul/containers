target "docker-metadata-action" {}

variable "APP" {
  default = "hermes-agent"
}

variable "VERSION" {
  // renovate: datasource=docker depName=docker.io/nousresearch/hermes-agent
  default = "v0.23.3"
}

variable "SOURCE" {
  default = "https://github.com/NousResearch/hermes-agent"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64"
  ]
}
