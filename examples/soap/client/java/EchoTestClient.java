/*
 * The Apache Software License, Version 1.1
 *
 *
 * Copyright (c) 2001 The Apache Software Foundation.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *       "This product includes software developed by the
 *        Apache Software Foundation (http://www.apache.org/)."
 *    Alternately, this acknowledgment may appear in the software itself,
 *    if and wherever such third-party acknowledgments normally appear.
 *
 * 4. The names "SOAP" and "Apache Software Foundation" must
 *    not be used to endorse or promote products derived from this
 *    software without prior written permission. For written
 *    permission, please contact apache@apache.org.
 *
 * 5. Products derived from this software may not be called "Apache",
 *    nor may "Apache" appear in their name, without prior written
 *    permission of the Apache Software Foundation.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE APACHE SOFTWARE FOUNDATION OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 */

package samples.interop;

import java.util.Vector;
import org.apache.soap.*;
import org.apache.soap.encoding.SOAPMappingRegistry;
import org.apache.soap.encoding.soapenc.*;
import org.apache.soap.rpc.*;
import org.apache.soap.messaging.*;
import java.net.URL;
import org.apache.soap.util.xml.*;
import java.io.*;
import org.w3c.dom.*;
import org.apache.soap.util.*;
import java.lang.reflect.*;
import java.util.Date;
import java.math.BigDecimal;

/** A quick-and-dirty client for the Interop echo test services as defined
 * at http://www.xmethods.net/ilab.
 * 
 * Defaults to the Apache endpoint, but you can point it somewhere else via
 * the command line:
 * 
 *    EchoTestClient http://some.other.place/
 * 
 * DOES NOT SUPPORT DIFFERENT SOAPACTION URIS YET.
 * 
 * @author Glen Daniels (gdaniels@macromedia.com)
 * @author Sam Ruby (rubys@us.ibm.com)
 */
public class EchoTestClient
{
  SOAPMappingRegistry smr = new SOAPMappingRegistry();

  public static final String DEFAULT_URL = "http://nagoya.apache.org:5089/soap/servlet/rpcrouter";
  public static final String ACTION_URI = "http://soapinterop.org/";
  public static final String OBJECT_URI = "http://soapinterop.org/xsd";
  public Header header = null;
  
  public static void main(String args[])
  {
    URL url = null;

    try {
      if (args.length > 0) {
        url = new URL(args[0]);
      } else {
        url = new URL(DEFAULT_URL);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    
    EchoTestClient eTest = new EchoTestClient();
    eTest.doWork(url);
  }

  private static boolean equals(Object obj1, Object obj2) {
    if ((obj1==null) || (obj2==null)) return (obj1==obj2);
    if (obj1.equals(obj2)) return true;
    if (obj1 instanceof Date && obj2 instanceof Date)
      if (Math.abs(((Date)obj1).getTime()-((Date)obj2).getTime())<1000)
        return true;
    if (!obj2.getClass().isArray()) return false;
    if (!obj1.getClass().isArray()) return false;
    if (Array.getLength(obj1) != Array.getLength(obj2)) return false;
    for (int i=0; i<Array.getLength(obj1); i++)
      if (!equals(Array.get(obj1,i),Array.get(obj2,i))) return false;
    return true;
  }
  
  public void doWork(URL url)
  {
    IntDeserializer intDser = new IntDeserializer();
    FloatDeserializer floatDser = new FloatDeserializer();
    StringDeserializer stringDser = new StringDeserializer();
    ArraySerializer arraySer = new ArraySerializer();
    DataSerializer dataSer = new DataSerializer();
    Base64Serializer base64Ser = new Base64Serializer();
    DateSerializer dateSer = new DateSerializer();
    DecimalDeserializer decimalSer = new DecimalDeserializer();
    BooleanDeserializer booleanSer = new BooleanDeserializer();
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName(OBJECT_URI, "SOAPStruct"), Data.class, dataSer, dataSer);

    Integer i = new Integer(5);
    Parameter p = new Parameter("inputInteger", Integer.class, i, null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, intDser);
    doCall(url, "echoInteger", p);
    
    p = new Parameter("inputFloat", Float.class, new Float(55.5), null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, floatDser);
    doCall(url, "echoFloat", p);
    
    p = new Parameter("inputString", String.class, "Hi there!", null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, stringDser);
    doCall(url, "echoString", p);
    
    p = new Parameter("inputStruct", Data.class, new Data(5, "Hola, baby", (float)10.0), null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, dataSer);
    doCall(url, "echoStruct", p);
    
    p = new Parameter("inputIntegerArray", Integer[].class, new Integer[]{
                      new Integer(5),
                      new Integer(4),
                      new Integer(3),
                      new Integer(2),
                      new Integer(1)}, null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, arraySer);
    doCall(url, "echoIntegerArray", p);		

    p = new Parameter("inputFloatArray", Float[].class, new Float[]{
                      new Float(5.5),
                      new Float(4.4),
                      new Float(3.3),
                      new Float(2.2),
                      new Float(1.1)}, null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, arraySer);
    doCall(url, "echoFloatArray", p);		

    p = new Parameter("inputStringArray", String[].class, new String[]{
                      "First",
                      "Second",
                      "Fifth (just kidding :))",
                      "Fourth",
                      "Last"}, null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, arraySer);
    doCall(url, "echoStringArray", p);		

    p = new Parameter("inputStructArray", Data[].class, new Data[]{
                      new Data(5, "cinqo", new Float("5.55555").floatValue()),
                      new Data(4, "quattro", (float)4.4444),
                      new Data(3, "tres", (float)3.333),
                      new Data(2, "duet", (float)2.22),
                      new Data(1, "un", (float)1.1)}, null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, arraySer);
    doCall(url, "echoStructArray", p);		

    doCall(url, "echoVoid", null);		

    p = new Parameter("inputBase64", byte[].class, "ciao".getBytes(), null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, base64Ser);
    doCall(url, "echoBase64", p);		

    p = new Parameter("inputDate", Date.class, new Date(), null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, dateSer);
    doCall(url, "echoDate", p);		

    p = new Parameter("inputDecimal", BigDecimal.class, new BigDecimal("3.14159"), null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, decimalSer);
    doCall(url, "echoDecimal", p);		

    p = new Parameter("inputBoolean", Boolean.class, new Boolean(true), null);
    smr.mapTypes(Constants.NS_URI_SOAP_ENC, new QName("", "return"), null, null, booleanSer);
    doCall(url, "echoBoolean", p);		

  }
  
  public void doCall(URL url, String methodName, Parameter param)
  {
    try {
      Call call = new Call();
      Vector params = new Vector();
      if (param != null) 
        params.addElement(param);
      call.setSOAPMappingRegistry(smr);
      call.setTargetObjectURI(ACTION_URI);
      call.setEncodingStyleURI(Constants.NS_URI_SOAP_ENC);
      call.setMethodName(methodName);
      call.setParams(params);
      if (header != null)
        call.setHeader(header);
      
      String soapAction = ACTION_URI;
      if (false) {
        soapAction = soapAction + methodName;
      }
      
      Response resp = call.invoke(url, soapAction);
      
      // check response 
      if (!resp.generatedFault()) {
        Parameter ret = resp.getReturnValue();
        Object output = (ret==null) ? null : ret.getValue();
        Object input = (param==null) ? null : param.getValue();

        if (equals(input,output)) {
          System.out.println(methodName + "\t OK");
        } else {
          System.out.println(methodName + "\t FAIL: " + output);
        }
      }
      else {
        Fault fault = resp.getFault ();
        System.out.println (methodName + " generated fault: ");
        System.out.println ("  Fault Code   = " + fault.getFaultCode());  
        System.out.println ("  Fault String = " + fault.getFaultString());
      }
      
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
