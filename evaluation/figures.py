from __future__ import division

from analyze_task_2 import parse_files, task_2_corrected_error_by_participant, \
    task_2_input_time_by_char

from collections import OrderedDict
import os
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np


def task_1_err_by_participant(base_path, data_filename, output_filename):
    fp = open(base_path + data_filename)
    lines = fp.readlines()
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

    factor = 8
    width = factor * 0.2
    group_locs = factor * np.array([0, 1, 2, 3])
    bar_locs = factor * np.array([0.1, 0.3, 0.5, 0.7])  # offset of each bar
    fig, ax = plt.subplots(figsize=(9,3))
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

    ax.set_title('Task 1 error rate by participant')
    ax.set_xticks(group_locs + np.mean(bar_locs))
    ax.set_xticklabels(('p0', 'p1', 'p2', 'p3'))
    plt.xlabel('participant')

    plt.ylabel('error rate')
    ax.set_ylim([0, 0.3])

    plt.legend(
        series, 
        (
            'session 1, task 1.1',
            'session 1, task 1.2',
            'session 2, task 1.1',
            'session 2, task 1.2',
        )
    )

    plt.tight_layout()
    plt.savefig(base_path + output_filename)
    #plt.show()


def task_2_err_by_participant(base_path, out_file):
    raw = parse_files()
    data = task_2_corrected_error_by_participant(raw)

    session1 = [p[0] for p in data]
    session2 = [p[1] for p in data]

    width = 0.4
    group_xs = np.array([0, 1, 2, 3])
    bar_offsets = np.array([.1, .5])
    colors = ['C0', 'C2']
    
    fig, ax = plt.subplots(figsize=(5, 3))
    plt.style.use('seaborn-deep')

    series = []
    for idx, session in enumerate([session1, session2]):
        bars = ax.bar(bar_offsets[idx] + group_xs, session, width, color=colors[idx])
        series.append(bars)
        for i, x in enumerate(group_xs):
            ax.text(
                x + bar_offsets[idx],
                session[i] + 0.001,
                '{}'.format(session[i]),
                ha='center',
            )
                
    plt.legend(
        (series[0][0], series[1][0]),
        ('session 1, task 2', 'session 2, task 2'),
    )

    ax.set_title('Task 2 error rate by participant')
    ax.set_xticks(group_xs + np.mean(bar_offsets))
    ax.set_xticklabels(('p0', 'p1', 'p2', 'p3'))
    plt.xlabel('participant')

    plt.ylabel('error rate')
    ax.set_ylim([0, 0.13])

    plt.tight_layout()
    plt.savefig(base_path + out_file)


def task_1_err_by_char(base_path, data_file, out_file):
    symbols = OrderedDict((
        ('0', 'zero'),
        ('1', 'one'),
        ('2', 'two'),
        ('3', 'three'),
        ('4', 'four'),
        ('5', 'five'),
        ('6', 'six'),
        ('7', 'seven'),
        ('8', 'eight'),
        ('9', 'nine'),
        ('.', 'decimal'),
        ('+', 'plus'),
        ('-', 'minus'),
        ('*', 'multiply'),
        ('/', 'divide'),
        ('^', 'power'),
        ('=', 'equals'),
        ('Del', 'delete'),
        ('C', 'clear'),
    ))

    fp = open(base_path + data_file)
    lines = fp.readlines()
    d = [line.strip().split(',') for line in lines]

    # get column 1 and column 25, rows 4-22 (0-indexed)
    data = {}
    for idx, line in enumerate(d):
        if idx >= 3 and idx <= 21:
            data[line[0]] = line[24]
    num_tasks = 8
    chart_data = [
        (label, float(data[symbols[label]])/num_tasks)
        for label in symbols
    ]

    width = 0.8
    bar_xs = np.array(range(19)) + 0.1
    color = 'C0'

    fig, ax = plt.subplots(figsize=(6, 2.8))
    plt.style.use('seaborn-deep')

    bar_hts = [pair[1] for pair in chart_data]
    bars = ax.bar(bar_xs, bar_hts, width)

    ax.set_title('Task 1 error rate by character')
    plt.ylabel('error rate')
    plt.xlabel('character')
    ax.set_xticks(np.array(range(19)))
    ax.set_xticklabels([pair[0] for pair in chart_data])
    ax.yaxis.set_major_locator(ticker.MultipleLocator(1/8))

    plt.tight_layout()
    plt.savefig(base_path + out_file)
    #plt.show()
    

def task_2_time_by_char(base_path, out_path):
    raw = parse_files()
    data = task_2_input_time_by_char(raw)  # [(char, avg_time)] 

    width = 0.8
    bar_xs = np.array(range(19)) + 0.1
    color = 'C0'

    fig, ax = plt.subplots(figsize=(9, 3))
    plt.style.use('seaborn-deep')

    bar_hts = [pair[1] for pair in data]
    bars = ax.bar(bar_xs, bar_hts, width)
    for i, bar_x in enumerate(bar_xs):
        ax.text(bar_x, bar_hts[i] + 0.05, '{:.2f}'.format(bar_hts[i]), ha='center')

    ax.set_title('Task 2 average input time of each character*')

    plt.ylabel('time (sec)')
    ax.set_ylim([0, 3.2])

    plt.xlabel('character')
    ax.set_xticks(np.array(range(19)))
    ax.set_xticklabels([pair[0] for pair in data])

    plt.tight_layout()
    plt.savefig(base_path + out_path)
    plt.show()


if __name__ == '__main__':
    base_path = os.getcwd()  # run from evaluation dir
    task_1_err_by_participant(
        base_path, 
        '/raw_data/task1.csv',
        '/fig/t1_err_by_participant.png',
    )

    task_2_err_by_participant(
        base_path, 
        '/fig/t2_err_by_participant.png',
    )

    task_1_err_by_char(
        base_path, 
        '/raw_data/task1.csv',
        '/fig/t1_err_by_char.png',
    )
    
    task_2_time_by_char(
        base_path,
        '/fig/t2_time_by_char.png',
    )


