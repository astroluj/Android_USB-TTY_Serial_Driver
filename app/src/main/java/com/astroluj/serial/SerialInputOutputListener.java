/* Copyright 2011-2013 Google Inc.
 * Copyright 2013 mike wakerly <opensource@hoho.com>
 *
 * Project home page: https://github.com/mik3y/usb-serial-for-android
 */

package com.astroluj.serial;

/**
 *
 * @author mike wakerly (opensource@hoho.com)
 */
public interface SerialInputOutputListener {
    /**
     * Ready when incoming is connect.
     */
    void onReadyRun();

    /**
     * Called when new incoming data is available.
     */
    void onNewData(byte[] data);

    /**
     * Called aborts due to an error.
     */
    void onRunError(Exception e);
}
