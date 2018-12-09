import os

## TODO: remove * when it occurs directly before ^ ?
## todo: magic number 15

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


# prompt -- [(char,stamp),...] for all the chars of one prompt
# session -- [promptid: [(char,stamp),]] for all the prompts in one session
# participant -- [sid: [promptid: [(char,stamp),...]]] for all the sessions for one participant
# study -- [pid: [promptid: [(char,stamp),...]]] for all participants

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

        parts = parse_line(line)

        # ^ replaces *
        if parts[0] == '^':
            if len(prompt) > 0 and prompt[-1][0] == '*':
                prompt[-1] = parts
            else:
                raise "^ follows something besides *"
        else:
            prompt.append(parse_line(line))

    # reached end of current prompt, session, and participant.
    return participant
        

def parse_files():
    wd = os.getcwd() # should execute from evaluation directory
    base_path = wd + '/raw_data/task2/'
    files = [
        'venkatesh.txt',
        'rashmi.txt',
        'nick.txt',
        'beibin.txt',
    ]
    participants = []
    for filename in files:
        participant = parse_one_file(base_path + filename)
        participants.append(participant)

    return participants


def print_participant(participant):
    sid = 0
    for session in participant:
        print 'session', sid
        sid += 1
        prid = 0
        for prompt in session:
            print 'prompt', prid
            prid += 1
            for char in prompt:
                print char
        print '\n'


def print_data(data):
    pid = 0
    for p in data:
        print 'participant', pid
        pid += 1
        print_participant(p)


def check_well_formed(data):
    for participant in data:
        for session in participant:
            print len(session)


if __name__ == '__main__':
    data = parse_files()
    check_well_formed(data)

