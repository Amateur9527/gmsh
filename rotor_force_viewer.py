#!/usr/bin/env python3

import sys
import numpy as np
from matplotlib import pyplot as plt
import warnings
import math
###define calculate parameters
a = 340
time = 0.05
Frames = 10
omega = 35
u = 10

if __name__ == '__main__':
    if len(sys.argv) < 5:
       print(f'python3 {sys.argv[0]}.py <case> <i_frame_min> <i_frame_max> <n_part>')
       exit(-1)
    case = sys.argv[1]
    i_frame_min = int(sys.argv[2])
    i_frame_max = int(sys.argv[3])
    n_part = int(sys.argv[4])
    Forces = np.array(range(33)).reshape(11,3)
    time_step = time / Frames
    k = omega * 2 * math.pi
    mach = format(k / a, '.2f')
    μ = format(u / k, '.2f')
    horizon = []
    i = 0
    for frame in range(Frames+1):
        horizon.append(float(format(i, '.3f')))
        i += time_step
    for i_frame in range(i_frame_min, i_frame_max+1):
        data = []
        n_row = 0
        for i_part in range(n_part):
            with warnings.catch_warnings():
                warnings.simplefilter('ignore')
                data.append(np.loadtxt(f'{case}/Frame{i_frame}/{i_part}.csv',
                    delimiter=',', skiprows=1))
            n_row += len(data[-1])
        points = np.ndarray((n_row, 3))
        forces = np.ndarray((n_row, 3))
        weights = np.ndarray(n_row)
        i_row = 0
        for i_part in range(n_part):
            for row in data[i_part]:
                points[i_row] = row[0:3]
                forces[i_row] = -row[3:6]
                weights[i_row] = row[6]
                i_row += 1
        Forces[i_frame] = np.matmul(forces.T,weights)
        assert i_row == n_row
        force_norm_max = 0.0
        for force in forces:
            force_norm_max = max(force_norm_max, np.linalg.norm(force))
        forces /= force_norm_max
        forces *= 0.5
        fig = plt.figure()
        ax = fig.add_subplot(projection='3d')
        ax.set_aspect('equal')
        ax.quiver(points[:,0], points[:,1], points[:,2],
            forces[:,0], forces[:,1], forces[:,2])
            # forces[:,0], forces[:,1], forces[:,2], length=0.2, normalize=True)
        ax.set_xlabel('X')
        ax.set_ylabel('Y')
        ax.set_zlabel('Z')
        ax.plot([1], [0], [0])
        plt.title(f'Frame[{i_frame}]')
        plt.show()
    
    plt.plot(horizon, Forces[:, 2], linewidth=1)
    plt.scatter(horizon,Forces[:, 2], c='red', s=20)
    plt.title('Lift-Time', fontsize=24)
    plt.xlabel('Time', fontsize=14)
    plt.ylabel('Lift', fontsize=14)
    for frame in range(Frames+1):
        plt.text(horizon[frame], Forces[frame, 2], (horizon[frame], Forces[frame, 2]), fontsize=8)
    plt.show()
    print(f'time={time}, Frames={Frames}, μ={μ}, mach={mach}')