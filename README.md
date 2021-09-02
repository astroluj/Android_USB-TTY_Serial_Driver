# Android_USB-TTY_Serial_Driver
USB 연결 및 TTY 연결 드라이버 모듈

https://github.com/mik3y/usb-serial-for-android<br>
https://github.com/cepr/android-serialport-api<br>
를 이용하여 만든 통합 드라이버

<p><p>
<h2> example<br></h2>
<pre><code>
/***********************************USB Serial***********************************/<br>
// USB 시리얼 있는지 확인
@JvmStatic fun getUSB(context: Context): UsbSerialDriver? {
    (context.getSystemService(USB_SERVICE) as UsbManager).deviceList.values.forEach {
          return UsbSerialProber.getDefaultProber().probeDevice(it)
    }
    return null
}
@JvmStatic fun connectUSB(context: Context): Boolean {
    val driver = getUSB(context) ?: return false
    // connect driver
    usbSerialPort = driver.ports[0]
    usbSerialPort?.let {
        if (!it.isOpen) {
            val usbManager = (context.getSystemService(USB_SERVICE) as UsbManager)
            usbConnection = usbManager.openDevice(driver.device)
            it.open(usbConnection)
            // 통신 설정
            it.setParameters(
                BaudRate,
                UsbSerialPort.DATABITS_8,
                UsbSerialPort.STOPBITS_1,
                UsbSerialPort.PARITY_NONE
            )
        }
        // read thread 생성
        this.connectUSBSerialInOut()
        return true
    }
    return false
}
@JvmStatic fun connectUSBSerialInOut() {
    // read thread 생성
    usbSerialPort?.let {
        if (it.isOpen) {
            this.usbJob = GlobalScope.launch(Dispatchers.IO) {
                isUSBJobRun.set(true)
                serialIOCallback.onReadyRun()
                val data = ByteArray(JsonUtils.BUFFER_SIZE)
                while (isUSBJobRun.get()) {
                    try {
                        val size = it.read(data, DEFAULT_DELAY_TIME.toInt())
                        if (size > 0) serialIOCallback.onNewData(data.sliceArray(0 until size))
                    } catch (e: Exception) {
                        serialIOCallback.onRunError(e)
                        break
                    }
                }
            }
        }
    }
}
/***********************************USB Serial***********************************/
</code></pre>
<pre><code>
/***********************************TTY Serial***********************************/
// TTY 시리얼 있는 지 확인
@JvmStatic fun getTTY(name: String): String? {
    val entries = this.ttySerialPortFinder.allDevicesPath
    val idx = entries.indexOf(name)
    return if (idx >= 0) entries[idx] else null
}
//TTY 시리얼 연결
@JvmStatic fun connectTTY(name: String): Boolean {
		this.getTTY(name)?.let {
				if (it.isEmpty() || BaudRate < 0) throw InvalidParameterException()
				this.ttySerialPort = SerialPort(File(it), BaudRate, 0)
				// read thread 생성
				this.connectTTYSerialInOut()
				return true
		}
    return false
}
@JvmStatic fun connectTTYSerialInOut() {
    // read thread 생성
    this.ttySerialPort?.let {
        this.ttyJob = GlobalScope.launch(Dispatchers.IO) {
            isTTYJobRun.set(true)
            serialIOCallback.onReadyRun()
            val data = ByteArray(JsonUtils.BUFFER_SIZE)
            while (isTTYJobRun.get()) {
                val ttySerialPortInput = SerialPort(File(ttySerialDeviceName), BaudRate, 0)
                try {
                    val size = ttySerialPortInput.inputStream.read(data)
                    if (size > 0) serialIOCallback.onNewData(data.sliceArray(0 until size))
                } catch (e: Exception) {
                    serialIOCallback.onRunError(e)
                    break
                } finally {
                    ttySerialPortInput.inputStream.close()
                    ttySerialPortInput.close()
                }
            }
        }
    }
}
// 통신 데이터 쓰기
@JvmStatic fun writeTTY () {
    this.ttySerialPort?.let {
        try {
            it.outputStream.write(Data)
            it.outputStream.flush()
        } catch (e: Exception) {
            serialIOCallback.onRunError(e)
        }
    }
}
/***********************************TTY Serial***********************************/
</code></pre>
<code><pre>
/***********************************Default Serial***********************************/
// Serial 통신 callback init
private var serialIOCallback = object : SerialInputOutputListener {
    // 통신 준비 완료
    override fun onReadyRun() {
    }
    // 받은 데이터
    override fun onNewData(byteArray: ByteArray?) {
    }
    // 통신 에러 발생
    override fun onRunError(e: Exception?) {
        e?.printStackTrace()
    }
}
@JvmStatic fun disconnectSerialInOut() {
    // usb serial in/out release
    this.isUSBJobRun.set(false)
    this.usbJob?.cancel()
    this.usbJob = null
    // tty serial in/out release
    this.isTTYJobRun.set(false)
    this.ttyJob?.cancel()
    this.ttyJob = null
    this.ttySerialPort?.outputStream?.close()
}
@JvmStatic fun disconnect() {
    this.disconnectSerialInOut()
    // usb serial release
    try {
        usbSerialPort?.close()
    } catch (ignored: IOException) {
    } finally {
        usbSerialPort = null
    }
    // tty serial release
    this.ttySerialPort?.close()
    this.ttySerialPort = null
}
// 통신 데이터 쓰기
@JvmStatic fun writeUSB () {
    this.usbSerialPort?.let {
        if (it.isOpen)
            try {
                it.write(usbSendData, DEFAULT_DELAY_TIME.toInt())
            } catch (e: Exception) {
                serialIOCallback.onRunError(e)
            }
    }
}
/***********************************Default Serial***********************************/
</code></pre>
<p><p>

<h2>Dependency<br></h2>
Project build.gradle
<code><pre>
allprojects {
	repositories {
		...
		maven { url 'https://jitpack.io' }
	}
}
</pre></code>
Application build.gradle
<code><pre>
dependencies {
	implementation 'com.github.astroluj:Android_USB-TTY_Serial_Driver:1.0.9'
}
</pre></code>

<h2>License</h2><br>
<p style="font-size:x-large">
		<a href="https://github.com/mik3y/usb-serial-for-android">
				https://github.com/mik3y/usb-serial-for-android
		</a>
		<a href="https://github.com/cepr/android-serialport-api">
				https://github.com/cepr/android-serialport-api
		</a>
		<br>
		License :
		<a href="http://www.apache.org/licenses/LICENSE-2.0">
				Apache 2.0 License
		</a>
		<br>
		License :
		<a href="https://opensource.org/licenses/MIT">
				MIT License
		</a>
</p>
