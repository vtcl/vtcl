sdk:
	sudo flatpak install flathub org.gnome.Platform//41 org.gnome.Sdk//41
flatpak:
	rm .flatpak-builder/build/* -fr
	flatpak-builder --repo=repo --force-clean build-dir org.vtcl.VisualTcl.yaml
	flatpak build-bundle repo vtcl.flatpak org.vtcl.VisualTcl
	flatpak install vtcl.flatpak
	flatpak update org.vtcl.VisualTcl
clean:
	rm vtcl.flatpak repo/ build-dir/ .flatpak-builder/ -fr

