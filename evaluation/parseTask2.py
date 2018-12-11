import os

## TODO: remove * when it occurs directly before ^ ?


charset = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'Del', '+', '-', '*', '/', '=', 'C', '.', '^',
]

def is_valid_line(line):
    # return true if valid, false if not
    parts = line.split(':')
    if len(parts) != 2:
        return False
    if parts[0] not in charset:
        return False
    try:
        float(parts[1])
    except:
        return False
    return True


def parse_line(line):
    # return char, timestamp
    return line.split(':')


# prompt -- (char,stamp) for all the chars of one prompt
# session -- [promptid: [char:stamp]] for all the prompts in one session
# participant -- [sid: [promptid: [char:stamp]]] for all the sessions for one participant
# study -- [pid: [promptid: [char:stamp]]] for all participants

def parse_one_file(filename):
    # valid line is str:time, where str is in the charset and time parses as a float
    # each time we see a blank line followed by a valid line, assume that's the start of a prompt

    # read the file
    fp = open(filename)
    lines = fp.readlines()
    
    # keep track of the current participant, session, and prompt
    participant = []
    session = []
    prompt = []

    # iterate over lines
    for line in lines:

        # check if done collecting all the prompts of this session
        if len(session) == 15:
            participant.append(session)
            session = []

        if not is_valid_line(line):
            # we've reached the end of the current prompt (if there is a current prompt)
            if len(prompt) > 0:
                session.append(prompt)
                prompt = []
            continue

        prompt.append(parse_line(line))

    # reached end of current prompt, session, and participant.
    session.append(prompt)
    participant.append(session)
    return participant

        
if __name__ == '__main__':
    wd = os.getcwd()
    p0 = parse_one_file(wd + '/raw_data/task2/beibin.txt')
    print p0
    print p0[0]
    print p0[0][0]
    print p0[0][0][0]



