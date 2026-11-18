# Changelog

## [0.3.1](https://github.com/elelem-sh/tools/compare/v0.3.0...v0.3.1) (2026-11-18)


### Bug Fixes

* **deps:** drop pathname and accept the json that Ruby 4.0 ships ([040da50](https://github.com/elelem-sh/tools/commit/040da50fda52accce3f48e5f0a14697285f44c78))

## [0.3.0](https://github.com/elelem-sh/tools/compare/v0.2.0...v0.3.0) (2026-11-15)


### Bug Fixes

* a built command skips its prompt only after a person approved the tool that built it (elelem-sh/elelem.sh[#3](https://github.com/elelem-sh/tools/issues/3)) ([0f47899](https://github.com/elelem-sh/tools/commit/0f4789942fe36b780beab507f2d406286852ca1e))
* a command a tool builds itself does not ask again after the tool was approved (elelem-sh/elelem.sh[#3](https://github.com/elelem-sh/tools/issues/3)) ([097b5b9](https://github.com/elelem-sh/tools/commit/097b5b98411857bd2b94ea439a41ce175ac889cd))
* a failed verify check is an error, so the model sees ok: false ([acddd22](https://github.com/elelem-sh/tools/commit/acddd22fe00653bf5f09110dc4d84434f17e8f37))
* a failing git command is an error, and grep with no matches is not (elelem-sh/elelem.sh[#20](https://github.com/elelem-sh/tools/issues/20)) ([fedc829](https://github.com/elelem-sh/tools/commit/fedc8295646dfed601cc2e9120434738b9542ac1))
* ask before running a tool whose permission policy is misspelled ([4adf5f6](https://github.com/elelem-sh/tools/commit/4adf5f6d22230dca701cdd72b8ee45efc346655a))
* edit counts overlapping matches and edits files that are not UTF-8 (elelem-sh/elelem.sh[#21](https://github.com/elelem-sh/tools/issues/21)) ([c3c2f73](https://github.com/elelem-sh/tools/commit/c3c2f737358d9df67f4fd75a4c952c70ab960b60))
* edit fails when old is missing or repeated, and takes new literally (elelem-sh/elelem.sh[#21](https://github.com/elelem-sh/tools/issues/21)) ([c2fd4eb](https://github.com/elelem-sh/tools/commit/c2fd4eb9f78ce1c13717c9e04ac7d08e5256bb2a))
* end of input at a permission prompt refuses (elelem-sh/elelem.sh[#2](https://github.com/elelem-sh/tools/issues/2)) ([dd75f4b](https://github.com/elelem-sh/tools/commit/dd75f4b2d5749b6972f2cfc7e24718654c4f809d))
* git always asks for its exact command line, since repository config can make any git command run a program ([d50005a](https://github.com/elelem-sh/tools/commit/d50005a9be0d56f1561887f7abe55ee4c3be23bb))
* git asks once, at execute, for its exact command line ([4dc6bd9](https://github.com/elelem-sh/tools/commit/4dc6bd975c7fa3441af6baee50d72e8662a176eb))
* grep and glob also fall back when rg or fd cannot run (elelem-sh/elelem.sh[#20](https://github.com/elelem-sh/tools/issues/20)) ([8a5a5d7](https://github.com/elelem-sh/tools/commit/8a5a5d7924dcfebd310efbb8cbcb841e02de48c3))
* grep and glob fall back only when rg or fd is not installed (elelem-sh/elelem.sh[#20](https://github.com/elelem-sh/tools/issues/20)) ([43180e3](https://github.com/elelem-sh/tools/commit/43180e30477eeeec5388a953376c2b53f14b865b))
* grep, glob, list and git never take a model-chosen value as an option that runs a program ([0aca202](https://github.com/elelem-sh/tools/commit/0aca2029521e1793c0e631dfa4df24c7eafebe46))
* only Enter, y or yes allow at a permission prompt (elelem-sh/elelem.sh[#2](https://github.com/elelem-sh/tools/issues/2)) ([d853f3b](https://github.com/elelem-sh/tools/commit/d853f3bf714142ce1f1303744815baa1ab44af97))
* only read-only git commands share the git approval; any other git command asks for its exact command line ([bbc1a0f](https://github.com/elelem-sh/tools/commit/bbc1a0ff5bc66b9c95b145653942f768df90a1a1))
* permission prompts escape characters that could redraw them (elelem-sh/elelem.sh[#2](https://github.com/elelem-sh/tools/issues/2)) ([fa46378](https://github.com/elelem-sh/tools/commit/fa463789635d446fced2b84dc6358d51c9389ed5))
* permission prompts show the command, and verify is allowed by default (elelem-sh/elelem.sh[#3](https://github.com/elelem-sh/tools/issues/3)) ([97c3437](https://github.com/elelem-sh/tools/commit/97c3437b6ec494c9b27d61e6ab11ee2632d5d3ed))
* require elelem ~&gt; 0.12, the floor builtins/skills actually need ([48b5818](https://github.com/elelem-sh/tools/commit/48b5818282b37877d72c55aeb79ec20ded25c1b4))
* require elelem 0.13.1, verify each written file, and grep with no matches is not an error ([4dfab39](https://github.com/elelem-sh/tools/commit/4dfab39bb738f3e41e3d2cb28093a22204409911))
* verify escapes the path before passing it to the shell ([ed52cf8](https://github.com/elelem-sh/tools/commit/ed52cf8f4682225fff4d0a1380f6c44fb59dd614))
