UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)

FONT_DIR := ~/Library/Fonts
define list_pkgs_cmd
	brew bundle dump --file=Brewfile --force --no-describe
endef
define base_pkgs_cmd
	@fortune | cowsay | lolcat
endef

else

FONT_DIR := ~/.local/share/fonts
define list_pkgs_cmd
	comm -23 <(pacman -Qqen | sort) <(sort pkglist-base.txt) > pkglist.txt
	pacman -Qmq > pkglist-aur.txt
endef
define base_pkgs_cmd
	comm -23 <(pacman -Qqen | sort) <(sort pkglist.txt) > tmp.txt && \
	mv tmp.txt pkglist-base.txt
endef

endif

list-pkgs:
	$(list_pkgs_cmd)

base-pkgs:
	$(base_pkgs_cmd)

fresh:
	chmod +x ./fresh.sh ./install.sh ./config.sh
	./fresh.sh

install: install-fonts
	chmod +x ./install.sh
	./install.sh

cfg:
	chmod +x ./config.sh
	./config.sh

ssh:
	chmod +x ./ssh.sh
	./ssh.sh

list-code-exts:
	codium --list-extensions > $(PWD)/vscodium/extensions.txt

PERSONAL_DIR := ~/Projects/Personal

define build_font_func
	cd $(PERSONAL_DIR) && \
	[ -d Iosevka ] || git clone --depth 1 git@github.com:be5invis/Iosevka.git && \
	cd Iosevka && \
	git reset && git clean -fd && git checkout -- . && \
	git pull && \
	npm install && \
	cp $(CURDIR)/fonts/$(1).toml ./private-build-plans.toml && \
	npm run build -- ttf-unhinted::$(1) --jCmd=4
	rm -rf fonts/$(1)
	cp -r $(PERSONAL_DIR)/Iosevka/dist/$(1) fonts/$(1)
endef

build-fonts:
	$(call build_font_func,ChiecAoMeVuaDanXong)
	$(call build_font_func,LySuaNongNgoaiBanCong)

define copy_font
	rm -rf $(2)/$(1)
	cp -r fonts/$(1) $(2)
endef

install-fonts: build-fonts
	$(call copy_font,ChiecAoMeVuaDanXong,$(FONT_DIR))
	$(call copy_font,LySuaNongNgoaiBanCong,$(FONT_DIR))

.PHONY: \
	list-pkgs \
	base-pkgs \
	fresh \
	install \
	cfg \
	ssh \
	list-code-exts \
	build-fonts \
	install-fonts \
	macos-list-pkgs \
	macos-install-fonts
