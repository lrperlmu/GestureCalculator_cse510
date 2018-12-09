from __future__ import division

from collections import Counter, OrderedDict

from parse_task_2 import parse_files

## todo: magic number 8


answer_key = [
    '56*10=',
    '12/4=',
    '32+571=',
    '3^6=',
    '12.03+12.5=',
    '-34*2=',
    '28.951C',
    '48-60=',
    '29/-29=',
    '81.4*-3=',
    '1024.73C',
    '256^2=',
    '8+77=',
    '0.913C',
    '678-578=',
]
charset = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
     '.', '+', '-', '*', '/', '^', '=', 'Del', 'C',
]


def corrected_string(prompt):
    # compute the corrected string for this prompt
    ret = []
    for eid, element in enumerate(prompt):

        # apply all deletes
        if element[0] == 'Del':
            ret = ret[:-1]

        # apply clears only if it's not the last character of the input
        elif element[0] == 'C' and eid != len(prompt)-1:
            ret = []
        else:
            ret.append(element[0])
    return ret


# from https://stackoverflow.com/a/32558749/1783777
def levenshteinDistance(s1, s2):
    if len(s1) > len(s2):
        s1, s2 = s2, s1

    distances = range(len(s1) + 1)
    for i2, c2 in enumerate(s2):
        distances_ = [i2+1]
        for i1, c1 in enumerate(s1):
            if c1 == c2:
                distances_.append(distances[i1])
            else:
                distances_.append(1 + min((distances[i1], distances[i1 + 1], distances_[-1])))
        distances = distances_
    return distances[-1]


def compute_session_error(session, verbose=False):
    # weighted average of (levenshetein distance / prompt length)
    total_chars = 0
    total_lev_dist = 0

    #answer_key[prid]

    for prid, prompt in enumerate(session):
        response = corrected_string(prompt)
        answer = answer_key[prid]
        dist = levenshteinDistance(response, answer)
        total_chars += len(answer)
        total_lev_dist += dist

        if verbose:
            print [e[0] for e in prompt]
            print response
            print answer
            print dist, '\n'

            print total_chars
            print total_lev_dist
            print '\n'
    
    return total_lev_dist / total_chars


def task_2_corrected_error_by_participant(data):
    ret = []
    for pid, participant in enumerate(data):
        participant_scores = []
        for sid, session in enumerate(participant):
            verbose = False
            # if pid == 0 and sid == 1:
            #     verbose = True
            se = compute_session_error(session, verbose)
            participant_scores.append(se)
            print 'p{}s{}: {}'.format(pid, sid, se)
        ret.append(participant_scores)
    return ret


def task_2_corrected_error_by_prompt(data):
    error_count_by_prompt = Counter()
    for participant in data:
        for session in participant:
            for prid, prompt in enumerate(session):
                response = corrected_string(prompt)
                answer = answer_key[prid]
                dist = levenshteinDistance(response, answer)
                error_count_by_prompt[prid] += dist

    ret = []
    for prid, prompt in enumerate(answer_key):
        # count / total
        count = error_count_by_prompt[prid]
        total = len(answer_key[prid]) * 8
        ret.append(count/total)
    return ret


# prompt -- [(char,stamp),...] for all the chars of one prompt
# session -- [prompt, ...] for all the prompts in one session
# participant -- [session, ...] for all the sessions for one participant
# study -- [particpant, ...] for all participants


def task_2_input_time_by_char(data):
    # compute intput time for each character that was not the first
    # (explain in paper why not first)
    char_counts = Counter()  # char: count
    char_times = Counter()  # char: total time
    
    for participant in data:
        for session in participant:
            for prompt in session:
                prev_stamp = 0
                cur_stamp = 0
                for char, stamp in prompt:
                    prev_stamp = float(cur_stamp)
                    cur_stamp = float(stamp)
                    if prev_stamp == 0:
                        continue
                    dif = cur_stamp - prev_stamp
                    char_counts[char] += 1
                    char_times[char] += dif
                    print char_counts
                    print char_times
                    print '\n'

    ret = [(c, char_times[c] / char_counts[c]) for c in charset]
    return ret


if __name__ == '__main__':
    data = parse_files()
    results = task_2_corrected_error_by_participant(data)
    print results, '\n'

    results2 = task_2_corrected_error_by_prompt(data)
    for prid, error_rate in enumerate(results2):
        print 'prompt{} error rate: {}'.format(prid, error_rate)
    print '\n'

    results3 = task_2_input_time_by_char(data)
    print results3
