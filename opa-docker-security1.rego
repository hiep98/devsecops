package main

# Do Not store secrets in ENV variables
secrets_env = [
    "passwd",
    "password",
    "pass",
    "secret",
    "key",
    "access",
    "api_key",
    "apikey",
    "token",
    "tkn"
]

deny[msg] {    
    input.Cmd == "env"
    val := input.Value
    contains(lower(val[_]), secrets_env[_])
    msg = sprintf("Line %d: Potential secret in ENV key found: %s", [input.Line, val])
}

# Only use trusted base images
deny[msg] {
    input.Cmd == "from"
    val := split(input.Value[0], "/")
    count(val) > 1
    msg = sprintf("Line %d: use a trusted base image", [input.Line])
}

# Do not use 'latest' tag for base image
deny[msg] {
    input.Cmd == "from"
    val := split(input.Value[0], ":")
    contains(lower(val[1]), "latest")
    msg = sprintf("Line %d: do not use 'latest' tag for base images", [input.Line])
}

# Avoid curl bashing
deny[msg] {
    input.Cmd == "run"
    val := concat(" ", input.Value)
    matches := regex.find_n("(curl|wget)[^|^>]*[|>]", lower(val), -1)
    count(matches) > 0
    msg = sprintf("Line %d: Avoid curl bashing", [input.Line])
}

# Do not upgrade your system packages
warn[msg] {
    input.Cmd == "run"
    val := concat(" ", input.Value)
    matches := regex.match(".*?(apk|yum|dnf|apt|pip).+?(install|[dist-|check-|group]?up[grade|date]).*", lower(val))
    matches == true
    msg = sprintf("Line: %d: Do not upgrade your system packages: %s", [input.Line, val])
}

# Do not use ADD if possible
deny[msg] {
    input.Cmd == "add"
    msg = sprintf("Line %d: Use COPY instead of ADD", [input.Line])
}

# Any user...
any_user {
    input.Cmd == "user"
}

deny[msg] {
    not any_user
    msg = "Do not run as root, use USER instead"
}

# ... but do not root
forbidden_users = [
    "root",
    "toor",
    "0"
]

deny[msg] {
    command := "user"
    users := [name | input[i].Cmd == command; name := input[i].Value]
    lastuser := users[count(users)-1]
    contains(lower(lastuser[_]), forbidden_users[_])
    msg = sprintf("Line %d: Last USER directive (USER %s) is forbidden", [input.Line, lastuser])
}

# Do not use sudo
deny[msg] {
    input.Cmd == "run"
    val := concat(" ", input.Value)
    contains(lower(val), "sudo")
    msg = sprintf("Line %d: Do not use 'sudo' command", [input.Line])
}

# Use multi-stage builds
#default multi_stage = false
#multi_stage = true {
#    input.Cmd == "copy"
#    val := concat(" ", input.Flags)
#    contains(lower(val), "--from=")
#}

#deny[msg] {
#    multi_stage == false
#    msg = sprintf("You COPY, but do not appear to use multi-stage builds...", [])
#}
