{ pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.rocm-core
      rocmPackages.rocm-runtime
      rocmPackages.rocm-device-libs
      rocmPackages.hipblas
      rocmPackages.hipfft
      rocmPackages.hipify
      rocmPackages.hipsolver
      rocmPackages.hipsparse
      rocmPackages.miopen
      rocmPackages.rocminfo
    ];
  };
  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };
  environment.systemPackages = with pkgs; [
    rocmPackages.clr.icd
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    rocmPackages.amdsmi
  ];
}
