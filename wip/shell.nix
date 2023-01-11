{pkgs ? import <nixpkgs> {}
}:

#pkgs.mkShell {
#	name = "python-environment";
#	buildInputs = [
		let 
			mach-nix = import (builtins.fetchGit {
			url = "https://github.com/DavHau/mach-nix/";
			ref = "refs/tags/3.5.0";
			}) { 
#				pkgs = import pkgs.age;
				python = "python38";
			};
		in
			mach-nix.mkPythonShell {
			requirements = ''
				cryptography
			'';
		}
	#];
#}
