# camcap: a tool for scheduled video stream capturing

These scripts simplifies using `ffmpeg` for scheduled capturing stream  videos from ip cameras.

## Dependencies

`ffmpeg`, `sed`, `timeout` and `crontab` should be installed a priori

```
 apt-get install coreutils sed ffmpeg cron
```
## Usage
```
camcap.sh [camcap_file]
```
`camcap_file` is the configuration file that defines the video streams and timings for capturing. If not provided default `camcapfile` is chosen. The script makes a crontab file based on this configuration file and installs it for current users. Captured videos as well as log files are written in the in the home directory of the user. For each stream a separated directory is made using the stream url as name (non alphanumerical characters are substituded by `_`).

The installed crontab file can be viewed by
```
crontab -l
```
And the scheduler can be stoped by
```
crontab -r
```
## Configuration File
The stream urls and the schedule for capturing are defined in a configuration file. The syntax for configuration file is as follows:

- Line starts with '#' is regarded as comment
- Empty lines are ignored
- Each task is written in one line

The syntax for task definition is:

```
┌──── capture duration in seconds (e.g. 100)
│ ┌───── min (same as crontab format)
│ │ ┌───── hour (same as crontab format)
│ │ │ ┌───── day of month (same as crontab format)
│ │ │ │ ┌───── month (same as crontab format)
│ │ │ │ │ ┌───── day of week (same as crontab format)
│ │ │ │ │ │
* * * * * * stream_url stream_format
```
the `stream_format` is the video format of the stream, e.g. `mjpeg`.

Example task definition:
```
# capture the url for 10 minutes everyday at 9:00, 10:00, 11:00, and 12:00
600 0 9-12 * * * http://141.89.114.98/cgi-bin/video320x240.mjpg mjpeg
# capture the url for one minute each 2 minutes
60  */2 * * * * http://camera.ehps.ncsu.edu:8100/c8 mjpeg
```
## Related
in [recordcam] a script is provided for capturing video from ip cameras.

[recordcam]: https://lucatnt.com/2014/08/record-and-archive-video-from-ip-cameras/ "Record and archive video from IP cameras"
