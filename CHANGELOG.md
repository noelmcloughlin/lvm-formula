# Changelog

## [0.3.2](https://github.com/saltstack-formulas/lvm-formula/compare/v0.3.1...v0.3.2) (2019-10-12)


### Bug Fixes

* **rubocop:** add fixes using `rubocop --safe-auto-correct` ([](https://github.com/saltstack-formulas/lvm-formula/commit/ce2077b))


### Continuous Integration

* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([](https://github.com/saltstack-formulas/lvm-formula/commit/914d3d6))
* **travis:** merge `rubocop` linter into main `lint` job ([](https://github.com/saltstack-formulas/lvm-formula/commit/10242fd))

## [0.3.1](https://github.com/saltstack-formulas/lvm-formula/compare/v0.3.0...v0.3.1) (2019-10-10)


### Bug Fixes

* **create.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/lvm-formula/commit/2ef61f3))
* **create.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/lvm-formula/commit/ab327b6))
* **trailing whitespace:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/lvm-formula/commit/0ff8bc9))


### Continuous Integration

* **kitchen:** install required packages to bootstrapped `opensuse` [skip ci] ([](https://github.com/saltstack-formulas/lvm-formula/commit/44810fd))
* **kitchen:** use bootstrapped `opensuse` images until `2019.2.2` [skip ci] ([](https://github.com/saltstack-formulas/lvm-formula/commit/c31b572))
* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([](https://github.com/saltstack-formulas/lvm-formula/commit/b8b3b6b))

# [0.3.0](https://github.com/saltstack-formulas/lvm-formula/compare/v0.2.4...v0.3.0) (2019-09-25)


### Bug Fixes

* **packages:** map  thin-provisioning-tools package ([1db0237](https://github.com/saltstack-formulas/lvm-formula/commit/1db0237))
* **pillardata:** clustered=>shared; fix yamllint issues ([7ce18d8](https://github.com/saltstack-formulas/lvm-formula/commit/7ce18d8))


### Code Refactoring

* **statenames:** renamed remove to clean ([e9bd497](https://github.com/saltstack-formulas/lvm-formula/commit/e9bd497))


### Documentation

* **example:** updated pillar.example ([47e5843](https://github.com/saltstack-formulas/lvm-formula/commit/47e5843))
* **readme:** fix duplicate clean; remove unused config.sls file ([804749e](https://github.com/saltstack-formulas/lvm-formula/commit/804749e))


### Features

* **lint:** add yamllint file ([8eb8a48](https://github.com/saltstack-formulas/lvm-formula/commit/8eb8a48))
* **semantic-release:** implement for this formula ([454f0a1](https://github.com/saltstack-formulas/lvm-formula/commit/454f0a1))


### Tests

* **kitchen:** add bin/kitchen ([0ecb724](https://github.com/saltstack-formulas/lvm-formula/commit/0ecb724))
* **kitchen:** add gemfile ([50f235b](https://github.com/saltstack-formulas/lvm-formula/commit/50f235b))
* **travis:** add basic travis setup ([0d5e74e](https://github.com/saltstack-formulas/lvm-formula/commit/0d5e74e))
