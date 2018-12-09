from __future__ import division

import os
import matplotlib.pyplot as plt
import numpy as np

## todo: plot colors


def task_1_error_rate(filename):
    fp = open(filename)
    lines = fp.readlines()
    print lines[23]
    d = [line.split(',') for line in lines]
    
    rows = [23, 45]
    cols = [
        [3, 4], # p0
        [6, 7], # p1
        [9, 10], # p2
        [12, 13], # p3
    ]

    data = []
    for participant_cols in cols:
        data.append([
            float(d[i][j]) for j in participant_cols for i in rows
        ])
    print data

    factor = 8
    width = factor * 0.2
    group_locs = factor * np.array([0, 1, 2, 3])
    bar_locs = factor * np.array([0.1, 0.3, 0.5, 0.7])  # offset of each bar
    fig, ax = plt.subplots()
    plt.style.use('seaborn-deep')
    colors = ['C0', 'C2', 'C1', 'C3']
    for group_loc, participant_data in zip(group_locs, data):
        series = ax.bar(group_loc + bar_locs, participant_data, width, color=colors, bottom=0)
        for i, bar_loc in enumerate(bar_locs):
            ax.text(
                group_loc + bar_loc + width/2,
                participant_data[i] + 0.001,
                '{}'.format(participant_data[i]),
                ha='right',
                va='bottom',
            )

    ax.set_title('Task 1 error rates')
    ax.set_xticks(group_locs + np.mean(bar_locs) )
    ax.set_xticklabels(('p0', 'p1', 'p2', 'p3'))
    plt.legend(
        series, 
        (
            'session 1, task 1.1',
            'session1, task 1.2',
            'session2, taskt 1.1',
            'session2, task 1.2',
        )
    )
    plt.ylabel('error rate')
    plt.xlabel('participant')


    plt.tight_layout()

    

    plt.show()



if __name__ == '__main__':
    base_path = os.getcwd()  # run from evaluation dir
    task_1_error_rate(base_path + '/raw_data/task1.csv')
    

