package kubernetes.admission

# Deny privileged containers
deny_privileged[msg] {
  input.request.object.spec.containers[_].securityContext.privileged == true
  msg = "Privileged containers are not allowed."
}

# Deny hostNetwork usage
deny_host_network[msg] {
  input.request.object.spec.hostNetwork == true
  msg = "hostNetwork usage is not allowed."
}

# Deny hostPID usage
deny_host_pid[msg] {
  input.request.object.spec.hostPID == true
  msg = "hostPID usage is not allowed."
}

# Require resource limits
require_limits[msg] {
  container := input.request.object.spec.containers[_]
  not container.resources.limits.cpu
  not container.resources.limits.memory
  msg = "Resource limits (CPU and memory) must be set for all containers."
}

# Require liveness and readiness probes
require_probes[msg] {
  container := input.request.object.spec.containers[_]
  not container.livenessProbe
  not container.readinessProbe
  msg = "Liveness and readiness probes must be configured for all containers."
}

# Deny :latest image tag
deny_latest_tag[msg] {
  container := input.request.object.spec.containers[_]
  endswith(container.image, ":latest")
  msg = "Using :latest image tag is not allowed."
}

# Require standard labels
require_labels[msg] {
  not input.request.object.metadata.labels.app
  not input.request.object.metadata.labels.version
  msg = "Standard labels (app and version) must be defined."
}