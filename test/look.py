import zmq

def main():
    context = zmq.Context()
    socket = context.socket(zmq.REQ)
    socket.connect('tcp://127.0.0.1:8000')
    socket.send(b'foldr          look')
    response = socket.recv()
    print(response)

if __name__ == '__main__':
    main()
