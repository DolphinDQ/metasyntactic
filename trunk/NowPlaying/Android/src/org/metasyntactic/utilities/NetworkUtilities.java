//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

package org.metasyntactic.utilities;

import org.metasyntactic.threading.PriorityMutex;
import org.w3c.dom.Element;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NetworkUtilities {
  private static PriorityMutex mutex = new PriorityMutex();


  private NetworkUtilities() {

  }


  public static String downloadString(String url, boolean important) {
    try {
      return downloadString(new URL(url), important);
    } catch (MalformedURLException e) {
      throw new RuntimeException(e);
    }
  }


  private final static String[] charsets = new String[]{
      "UTF-8",
      "ISO-8859-1",
  };


  public static String downloadString(URL url, boolean important) {
    byte[] bytes = download(url, important);

    for (String charset : charsets) {
      String result = decode(bytes, charset);
      if (result != null) {
        return result;
      }
    }

    return null;
  }


  private static String decode(byte[] bytes, String charset) {
  	if (bytes == null) {
  		return null;
  	}

    try {
      Charset utfCharset = Charset.forName(charset);
      CharsetDecoder decoder = utfCharset.newDecoder();
      return decoder.decode(ByteBuffer.wrap(bytes)).toString();
    } catch (CharacterCodingException e) {
      return null;
    }
  }


  public static Element downloadXml(String url, boolean important) {
    try {
      return downloadXml(new URL(url), important);
    } catch (MalformedURLException e) {
      throw new RuntimeException(e);
    }
  }


  private static Element downloadXml(URL url, boolean important) {
    byte[] data = download(url, important);
    if (data == null || data.length == 0) {
    	return null;
    }
    return XmlUtilities.parseInputStream(new ByteArrayInputStream(data));
  }


  public static byte[] download(String url, boolean important) {
    if (StringUtilities.isNullOrEmpty(url)) {
      return null;
    }

    try {
      return download(new URL(url), important);
    } catch (MalformedURLException e) {
    	ExceptionUtilities.log(NetworkUtilities.class, "download", e);
    	return null;
    }
  }


  public static byte[] download(URL url, boolean important) {
    try {
      mutex.lock(important);
      return downloadWorker(url);
    } finally {
      mutex.unlock(important);
    }
  }


  private static byte[] downloadWorker(URL url) {
    try {
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      BufferedOutputStream bufferedOut = new BufferedOutputStream(out, 1 << 13);
      BufferedInputStream in = new BufferedInputStream(url.openStream(), 1 << 13);

      byte[] bytes = new byte[1 << 16];
      int length;
      while ((length = in.read(bytes)) > 0) {
        bufferedOut.write(bytes, 0, length);
      }

      bufferedOut.flush();
      out.flush();
      out.close();
      in.close();

      return out.toByteArray();
    } catch (IOException e) {
      ExceptionUtilities.log(NetworkUtilities.class, "downloadWorker", e);
      return null;
    }
  }
}
