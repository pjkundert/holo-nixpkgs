{ lib, ... }:

{
  imports = [
    ../.
    ../binary-cache.nix
    ../self-aware.nix
  ];

  time.timeZone = "UTC";

  # Anyone in this list is in a position to poison binary cache, commit active
  # MITM attack on hosting traffic, maliciously change client assets to capture
  # users' keys during generation, etc. Please don't add anyone to this list
  # unless absolutely required. Once U2F support in SSH stabilizes, we will
  # require that everyone on this list uses it along with a hardware token. We
  # also should set up sudo_pair <https://github.com/square/sudo_pair>.
  users.users.root.openssh.authorizedKeys.keys = lib.mkForce [
    # filalex77
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICp5OkzJW/6LQ1SYNTZC1hVg72/sca2uFOOqzZcORAHg"
    # PJ Klimek
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwtG0yk6e0szjxk3LgtWnunOvoXUJIncQjzX5zDiKxY"
    # evangineer
    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAo+FbntLXk628VDr8BJ4jygxnp2jl8FE9CTgwmGmT2eCAFbeFduJ/9Uzg7RFez6PdY5gXnOGpgtrPI7ZyIedb9mZLDRDyHQV9qY4HEOvYG6prVZi31Kvf4Ldh5puZXw8AqyE+igXo5AdPhbtJl9ZcbZR6p9/VP5a0AIzlRS5SzjPf+e0lDeYOc3IrzMVkDPz0XfVmeVnhGqv82cq1LYYbsmjGQnIBFQIX2znHFVU5+x7YVs0Nw+4ays0FxDyzvpK/gDW5OQsmgGOEWkOd4Ei1YRF2wNQki+SG3MC8RE19UB5kVuHutGJ7VA8NwBiEAITk6JCxXQo9bOcvh2Y4F0OnRQ=="
    # JettTech
    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAo+FbntLXk628VDr8BJ4jygxnp2jl8FE9CTgwmGmT2eCAFbeFduJ/9Uzg7RFez6PdY5gXnOGpgtrPI7ZyIedb9mZLDRDyHQV9qY4HEOvYG6prVZi31Kvf4Ldh5puZXw8AqyE+igXo5AdPhbtJl9ZcbZR6p9/VP5a0AIzlRS5SzjPf+e0lDeYOc3IrzMVkDPz0XfVmeVnhGqv82cq1LYYbsmjGQnIBFQIX2znHFVU5+x7YVs0Nw+4ays0FxDyzvpK/gDW5OQsmgGOEWkOd4Ei1YRF2wNQki+SG3MC8RE19UB5kVuHutGJ7VA8NwBiEAITk6JCxXQo9bOcvh2Y4F0OnRQ=="
    # zo-el
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1smdy0NKOaUaNx0ASklOt+pP7+UZrOrZmz+Uv7iLoVz6OGbTANBCPydSYr9NvoHeTljSd8Ma7Gvk/V0qf3VrxJn3YfC45IIRAdh8mqnGzXKA0YM+WpyUVOwYRYSzL/5HqUsNXaQvSwNZ/Sa8gGCHwysIfsoZP4ABui6HmGAOxD+8tqeEjUqD3jEyyjhPbkw/tL2RCIl2oJVi4Mrm91cIHTXcv1uNSGt/16vbQ3lroXZN+rzPA+nZkEfaw+xpgpW7QQvTaWecwyYqSH/D4scqjF9wBzLRS6fKlde6CKTZ3t6VMKJ0nQVtC1k5VAYlaBPGgDFMbDnCPXnjjCz74YYnsyxCKbpdJxf4Nwt6jL0CD5p5ipvT7l7V1h2z+s4ib6lmaIxE37fLKAMLgFRwmaW3olUWQ3jGlmSbMqbZI9EXvXNdeiYORaJy/FOUOX56ZKRF5imWY2ePrd39el4D3MfTconUhJVuO7p15A/Y8LzLP9dbsKddAOxlEFhYdnac9UkizMNzjWyMOFT0WebnoMhpi0DxKZJz7r2OeuYQlhl+ppo96RjAfDo6q2NsJIeIvLedKt0Qy8hJZco9tRG/sQ3lSa2c23qVUhiZl+KkheLcBGdOjCGJjhPyLr4rT/uefFaW7Ln88rlnwFZF0yxutKMzK+wxaZ+S+mt+H8GW31fnKkQ=="
  ];
}
