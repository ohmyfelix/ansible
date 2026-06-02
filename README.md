<h1 align=center>Dockette / Ansible</h1>

<p align=center>
   <a href="https://github.com/dockette/ansible/actions"><img src="https://github.com/dockette/ansible/actions/workflows/docker.yml/badge.svg" alt="GitHub Actions"></a>
   <a href="https://hub.docker.com/r/dockette/ansible"><img src="https://img.shields.io/docker/pulls/dockette/ansible.svg" alt="Docker Hub pulls"></a>
   <a href="https://github.com/sponsors/f3l1x"><img src="https://img.shields.io/badge/sponsor-GitHub%20Sponsors-ea4aaa" alt="GitHub Sponsors"></a>
   <a href="https://github.com/orgs/dockette/discussions"><img src="https://img.shields.io/badge/support-discussions-6f42c1" alt="Support/Discussions"></a>
</p>

<p align=center>
   Ansible + Ansiblelint
</p>

-----

## Usage

```
docker run -it --rm -v $(pwd):/srv dockette/ansible:debian-11 bash
```

**Images**

- dockette/ansible:debian-11
- dockette/ansible:debian-10

## Development

```sh
make build
make test
make run
```

## Maintenance

See [how to contribute](https://github.com/dockette/.github/blob/master/CONTRIBUTING.md) to this package. Consider to [support](https://github.com/sponsors/f3l1x) **f3l1x**. Thank you for using this package.
