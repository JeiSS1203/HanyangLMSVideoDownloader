import sys
import json
import subprocess
import shutil
import os
import traceback
import tempfile

LOG_PATH = os.path.join(os.path.expanduser('~'), 'downloader_debug.log')
LOCK_PATH = os.path.join(tempfile.gettempdir(), 'hanyang_ffmpeg_download.lock')


def log(message):
    try:
        with open(LOG_PATH, 'a', encoding='utf-8') as f:
            f.write(message + '\n')
    except Exception:
        pass


def read_message():
    raw_length = sys.stdin.buffer.read(4)
    if not raw_length:
        return None
    length = int.from_bytes(raw_length, 'little')
    data = sys.stdin.buffer.read(length)
    return json.loads(data.decode('utf-8'))


def send_message(response):
    try:
        encoded = json.dumps(response).encode('utf-8')
        sys.stdout.buffer.write(len(encoded).to_bytes(4, 'little'))
        sys.stdout.buffer.write(encoded)
        sys.stdout.flush()
    except Exception as e:
        log(f'send_message error: {e}')


def is_ffmpeg_available():
    return shutil.which('ffmpeg') is not None


def acquire_lock():
    if os.path.exists(LOCK_PATH):
        return False
    try:
        with open(LOCK_PATH, 'w', encoding='utf-8') as f:
            f.write(str(os.getpid()))
        return True
    except Exception as e:
        log(f'acquire_lock error: {e}')
        return False


def release_lock():
    try:
        if os.path.exists(LOCK_PATH):
            os.remove(LOCK_PATH)
    except Exception as e:
        log(f'release_lock error: {e}')


def run_ffmpeg(url):
    downloads = os.path.join(os.path.expanduser('~'), 'Downloads')
    os.makedirs(downloads, exist_ok=True)
    output = os.path.join(downloads, 'screen.mp4')

    headers = (
        'Referer: https://hycms.hanyang.ac.kr/\r\n'
        'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
        'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36\r\n'
    )

    cmd = [
        'ffmpeg',
        '-y',
        '-headers', headers,
        '-i', url,
        '-c', 'copy',
        output
    ]

    log(f'Running command: {cmd}')
    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        cwd=downloads
    )

    log(f'ffmpeg returncode: {result.returncode}')
    if result.stdout:
        log(f'ffmpeg stdout: {result.stdout.strip()}')
    if result.stderr:
        log(f'ffmpeg stderr: {result.stderr.strip()}')

    return result.returncode == 0, output, result.stderr


def main():
    try:
        log('Downloader started')

        if not is_ffmpeg_available():
            send_message({'status': 'error', 'message': 'ffmpeg not found'})
            return

        msg = read_message()
        if msg is None:
            log('No message, exiting')
            return

        url = msg.get('url')
        log(f'Received URL: {url}')

        if not url:
            send_message({'status': 'error', 'message': 'No URL provided'})
            return

        if not acquire_lock():
            log('Another download is already running')
            send_message({'status': 'busy', 'message': 'Download already in progress'})
            return

        try:
            ok, output, err = run_ffmpeg(url)
            if ok:
                send_message({'status': 'done', 'output': output})
            else:
                send_message({'status': 'error', 'message': err[-1000:] if err else 'ffmpeg failed'})
        finally:
            release_lock()

        log('Exiting normally')

    except Exception:
        log('Unexpected error: ' + traceback.format_exc())
        try:
            send_message({'status': 'error', 'message': 'unexpected exception'})
        except Exception:
            pass


if __name__ == '__main__':
    main()