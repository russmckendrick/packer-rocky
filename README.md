# Packer Rocky Linux

Packer config for the boxes which can be found at [https://app.vagrantup.com/russmckendrick/boxes/rocky](https://app.vagrantup.com/russmckendrick/boxes/rocky).

To build both Virtualbox and VMWare boxes run;

```
packer build rocky.pkr.hcl
```

For just VMWare;

```
packer build -only vmware-iso.vmware rocky.pkr.hcl
```

And for Virtualbox;

```
packer build -only virtualbox-iso.virtualbox rocky.pkr.hcl
```
