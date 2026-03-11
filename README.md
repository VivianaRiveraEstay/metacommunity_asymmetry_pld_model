# Metacommunity Predator–Prey Model with Asymmetric Dispersal

This repository contains the MATLAB code used to simulate a spatial predator–prey metacommunity model with asymmetric larval dispersal and species-specific connectivity matrices.

The code is associated with the manuscript:

**Rivera-Estay et al.**
*Asymmetric dispersal shapes spatial structure and dynamical regimes in predator–prey metacommunities*  
Submitted to *Journal of Mathematical Biology*.

## Description

The model describes predator and prey dynamics across multiple spatial patches connected by larval dispersal. Connectivity between patches is represented by species-specific numerical connectivity matrices that depend on pelagic larval duration (PLD) and directional transport asymmetry.

The simulations explore how:
- dispersal asymmetry,
- interspecific mismatches in dispersal symmetry, and
- dispersal distance (PLD)

affect spatial population structure, dynamical regimes, and extinction risk.

## Files

- `run_model.m` — main script used to run simulations and compute metrics.
- `ecosystem_model.m` — system of differential equations describing the predator–prey dynamics.
- `generate_asymmetric_connectivity.m` — function used to generate asymmetric connectivity matrices.

## Requirements

The code was developed and tested in **MATLAB**.

## How to run

Run the main script:

```matlab
run_model
