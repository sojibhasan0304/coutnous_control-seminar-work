# Continuous Control Seminar Work

This repository contains my seminar work for Continuous Control (AUART/AE4SR).

## System

The given system is:

```text
2y''(t) + 5y'(t) + y(t) = 2u'(t) + u(t)
```

Transfer function:

```text
G(s) = (2s + 1) / (2s^2 + 5s + 1)
```

## Repository Structure

```text
seminar-work/
├── README.md
├── report/
│   └── Seminer_work.pdf
├── assignment/
│   └── AE4SR - Seminary Work Assignment.pdf
├── code/
│   ├── task3_impulse_response.m
│   ├── task4_step_response.m
│   ├── task6_nyquist_plot.m
│   ├── task7_bode_plot.m
│   └── controllers_task8_9_16.m
└── figures/
    ├── impulse_response.png
    ├── step_response.png
    ├── nyquist_plot.png
    └── bode_plot.png
```

## Contents

* `report/` contains the final seminar work PDF.
* `assignment/` contains the original assignment PDF.
* `code/` contains MATLAB scripts for calculations and plots.
* `figures/` contains generated plots used in the report.

## Main Tasks

The report includes:

1. Transfer function
2. Poles, zeros, static gain, stability, and periodicity
3. Impulse response
4. Step response
5. Frequency transfer function
6. Algebraic frequency table and Nyquist plot
7. Goniometric frequency table and Bode plots
8. Polynomial algebraic controller design
9. PI controller design
10. Stability verification
11. State-space descriptions
12. Controllability and observability
13. State-feedback controller design

## How to Run the Code

Open MATLAB, go to the `code/` folder, and run:

```matlab
run_all
```

The generated plots and tables will be saved in the `figures/` folder.

## Required Software

* MATLAB
* Control System Toolbox
