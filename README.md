<div align="center">

<img src="https://umsousercontent.com/lib_lnlnuhLgkYnZdkSC/hj0vk05j0kemus1i.png" alt="ChipFoundry Logo" height="140" />

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Inter&size=44&duration=3000&pause=600&color=4C6EF5&center=true&vCenter=true&width=1100&lines=OpenFrame+User+Project+Template;OpenLane+%2B+ChipFoundry+Flow;Verification+and+Shuttle-Ready)](https://git.io/typing-svg)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ChipFoundry Marketplace](https://img.shields.io/badge/ChipFoundry-Marketplace-6E40C9.svg)](https://platform.chipfoundry.io/marketplace)

</div>

## Table of Contents
- [Overview](#overview)
- [Documentation & Resources](#documentation--resources)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Starting Your Project](#starting-your-project)
- [Development Flow](#development-flow)
- [Local Precheck](#local-precheck)
- [Checklist for Shuttle Submission](#checklist-for-shuttle-submission)

## Overview
This repository is a clone of [`chipfoundry/openframe_user_project`](https://github.com/chipfoundry/openframe_user_project) with [`CF_CARAVEL_SOC`](https://github.com/chipfoundry/CF_CARAVEL_SOC) (VexRiscv + housekeeping + DFFRAM) and a 16-bit Caravel counter placed as hard macros. The wrapper stays elaborate-only; pad configuration comes from the SoC, not `CF_gpio_config`.

OpenFrame is a ChipFoundry padframe (no integrated SoC) with a 15 mm² user area and 44 GPIOs.

### Pad map

| Pads | Source |
|---:|---|
| 7:0 | `CF_CARAVEL_SOC` (debug, housekeeping SPI, UART, IRQ) |
| 23:8 | Template counter `count[15:0]` |
| 31:24 | `CF_CARAVEL_SOC` |
| 37:32 | `CF_CARAVEL_SOC` (SPI master / QSPI) |
| 38 | External clock |
| 39 | SPI flash CSB |
| 40 | SPI flash CLK |
| 41 | SPI flash IO0 |
| 42 | SPI flash IO1 |
| 43 | Management GPIO / development-board LED |

### Layout

```text
  3166 x 4766  openframe_project_wrapper
  ┌─────────────────────────────────────┐
  │ counter_macro 400 x 400 @ (400,1800) │
  │                                     │
  ├─────────────────────────────────────┤ y ≈ 1750
  │         CF_CARAVEL_SOC              │
  │         2920 x 1700 @ (123, 50)     │
  └─────────────────────────────────────┘
```

Template keep-alive vias `vccd1_connection` / `vssd1_connection` stay at the official `macro.cfg` locations. Harden with `cf harden counter_macro` then `cf harden openframe_project_wrapper`. GDS streamout is Magic.

### Spice extraction

The default is LEF-based extraction with the SoC and counter abstracted, which finishes in seconds:

```json
"MAGIC_EXT_USE_GDS": false,
"MAGIC_EXT_ABSTRACT_CELLS": ["^CF_CARAVEL_SOC$", "^counter_macro$"],
"ERROR_ON_ILLEGAL_OVERLAPS": false
```

Abstracting every macro also abstracts `vccd1_connection` / `vssd1_connection`, whose LEFs are a blanket met3 obstruction. The PDN straps those cells exist to carry are then reported as 27 illegal overlaps, so the check is demoted to a warning. Only the `vccd1` / `vssd1` special nets reach them; no signal net does.

For a signoff run, extract from the streamed-out GDS instead, which reads the real geometry of the power vias and reports zero overlaps:

```json
"MAGIC_EXT_USE_GDS": true,
"ERROR_ON_ILLEGAL_OVERLAPS": true
```

Budget about an hour and 7 GB of container memory for that, since `MAGIC_EXT_ABSTRACT_CELLS` does not prevent Magic from extracting the SoC hierarchy once the GDS is read. Resume just that stage with:

```bash
cf harden openframe_project_wrapper --from Magic.SpiceExtraction --tag <run tag>
```

Both paths depend on `CF_CARAVEL_SOC.lef` keeping its obstructions clear of its pins; see `layout/trim_obs_over_pins.py` in the IP repository.

---

## Documentation & Resources
For detailed hardware specifications and design guidelines, refer to the following official documents:

* **[ChipFoundry Marketplace](https://platform.chipfoundry.io/marketplace)**: Access additional IP blocks, EDA tools, and shuttle services.

---

## Prerequisites
Ensure your environment meets the following requirements:

1. **Docker** [Linux](https://docs.docker.com/desktop/setup/install/linux/ubuntu/) | [Windows](https://docs.docker.com/desktop/setup/install/windows-install/) | [Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
2. **Python 3.8+** with `pip`.
3. **Git**: For repository management.

---

## Project Structure
A successful OpenFrame project requires a specific directory layout for the automated tools to function:

| Directory | Description |
| :--- | :--- |
| `openlane/` | Configuration files for hardening macros and the wrapper. |
| `verilog/rtl/` | Source Verilog code for the project. |
| `verilog/gl/` | Gate-level netlists (generated after hardening). |
| `verilog/dv/` | Design Verification (cocotb and Verilog testbenches). |
| `gds/` | Final GDSII binary files for fabrication. |
| `lef/` | Library Exchange Format files for the macros. |

---

## Starting Your Project

### 1. Repository Setup
Create a new repository based on the `openframe_user_project` template and clone it to your local machine:

```bash
git clone <your-github-repo-URL>
pip install chipfoundry-cli
cd <project_name>
```

### 2. Project Initialization

> [!IMPORTANT]
> Run this first! Initialize your project configuration:

```bash
cf init
```

This creates `.cf/project.json` with project metadata. **This must be run before any other commands**

### 3. Environment Setup
Install the ChipFoundry CLI tool and set up the local environment (PDKs, OpenLane, and OpenFrame):

```bash
cf setup
```

The `cf setup` command installs:

- OpenFrame: The OpenFrame harness template.
- OpenLane: The RTL-to-GDS hardening flow.
- PDK: Skywater 130nm process design kit.
- Timing Scripts: For Static Timing Analysis (STA).

---

## Development Flow

### Hardening the Design
Hardening is the process of synthesizing your RTL and performing Place & Route (P&R) to create a GDSII layout.

#### Macro Hardening
Create a subdirectory for each custom macro under `openlane/` containing your `config.json`.

```bash
cf harden --list         # List detected configurations
cf harden <macro_name>   # Harden a specific macro
```

#### Integration
Instantiate your module(s) in `verilog/rtl/openframe_project_wrapper.v`.

Update `openlane/openframe_project_wrapper/config.json` environment variables (`VERILOG_FILES_BLACKBOX`, `EXTRA_LEFS`, `EXTRA_GDS_FILES`) to point to your new macros.

#### Wrapper Hardening
Finalize the top-level user project:

```bash
cf harden openframe_project_wrapper
```

### Important Notes

**Connecting to Power:**
   - Ensure your design is connected to power using the power pins on the wrapper.
   - Use the `vccd1_connection` and `vssd1_connection` macros, which contain the necessary vias and nets for power connections.

### Verification

#### 1. Simulation
We use cocotb for functional verification. Ensure your file lists are updated in `verilog/includes/`.

Run RTL Simulation:

```bash
cf verify <test_name>
```

Run Gate-Level (GL) Simulation:

```bash
cf verify <test_name> --sim gl
```

Run all tests:

```bash
cf verify --all
```

---

## Local Precheck
Before submitting your design for fabrication, run the local precheck to ensure it complies with all shuttle requirements:

```bash
cf precheck
```

You can also run specific checks or disable LVS:

```bash
cf precheck --disable-lvs                    # Skip LVS check
cf precheck --checks license --checks makefile  # Run specific checks only
```
---

## Checklist for Shuttle Submission
- [ ] Top-level macro is named openframe_project_wrapper.
- [ ] Full Chip Simulation passes for both RTL and GL.
- [ ] Hardened Macros are LVS and DRC clean.
- [ ] openframe_project_wrapper matches the required pin order/template.
- [ ] Design is properly connected to power (vccd1/vssd1).
- [ ] Design passes the local cf precheck.
- [ ] Documentation (this README) is updated with project-specific details.
