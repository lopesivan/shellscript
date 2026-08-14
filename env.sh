export PATH=$(brew --prefix)/scripts/bin:$PATH
export QTFRAMEWORK_BYPASS_LICENSE_CHECK=1

# === OK para tmpfs volátil (output/scratch de build, não precisa sobreviver reboot) ===
export CARGO_TARGET_DIR=/workspace/.target
export CCACHE_DIR=/workspace/.ccache
export TMPDIR=/workspace/.tmp
export GOCACHE=/workspace/.go/cache
export PYTHONPYCACHEPREFIX=/workspace/.pycache
export DOCKER_CONFIG=/workspace/.docker # NÃO: guarda credenciais/config de login, perde auth a cada boot
export ANDROID_AVD_HOME=/workspace/.android/avd

# === NÃO recomendado (cache de dependências baixadas — redownload caro a cada boot) ===
# export GRADLE_USER_HOME=/workspace/.gradle             # NÃO: redownloada tudo do Maven Central
# export CARGO_HOME=/workspace/.cargo                    # NÃO: perde toolchains + crates.io baixados
# export RUSTUP_HOME=/workspace/.rustup                  # NÃO: perde toolchains instaladas (rebuild pesado)
# export GOPATH=/workspace/.go                           # NÃO: perde módulos baixados (parcial, ver GOMODCACHE)
# export GOMODCACHE=/workspace/.go/mod                   # NÃO: mesma razão, módulos Go baixados
# export PIP_CACHE_DIR=/workspace/.pip-cache             # NÃO: cache de wheels, redownload da PyPI
# export NPM_CONFIG_CACHE=/workspace/.npm                # NÃO: cache de tarballs npm
# export npm_config_prefix=/workspace/.npm-global        # NÃO: pacotes globais instalados, perderia binários
# export MAVEN_OPTS="-Dmaven.repo.local=/workspace/.m2"  # NÃO: repo local Maven, redownload pesado
# export ANDROID_SDK_HOME=/workspace/.android            # NÃO: SDK inteiro, reinstalação MUITO cara
# export ANDROID_AVD_HOME=/workspace/.android/avd        # NÃO: imagens de AVD são grandes, recriar é custoso
# export CONAN_USER_HOME=/workspace/.conan               # NÃO: pacotes Conan (wxWidgets), rebuild pesado
# export CONAN_HOME=/workspace/.conan2                   # NÃO: idem, Conan 2.x
# export LUAROCKS_CONFIG=/workspace/.luarocks/config.lua # NÃO: rocks instalados, reinstalação de plugins Lua

# === XDG (avaliar caso a caso, mistura cache volátil com config/estado que você quer manter) ===
# export XDG_CACHE_HOME=/workspace/.cache       # OK-ish: é cache por definição, mas builds grandes acumulam rápido
# export XDG_CONFIG_HOME=/workspace/.config     # NÃO: configs, não cache — perderia config toda a cada boot
# export XDG_DATA_HOME=/workspace/.local/share  # NÃO: dados de app (histórico, estado), não deveria ser volátil
# export XDG_STATE_HOME=/workspace/.local/state # NÃO: estado persistente por definição (histórico shell etc)

# DEBUG ON
[ $SCRIPT_DEBUG_ON ] && echo load file: env.sh
