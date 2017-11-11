package io.github.bertramn.issues;

import org.joda.time.DateTimeZone;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class TimeZoneXmlAdapter extends XmlAdapter<String, DateTimeZone> {

  @Override
  public DateTimeZone unmarshal(String dateTime) throws Exception {
    return dateTime == null ? null : DateTimeZone.forID(dateTime);
  }

  @Override
  public String marshal(DateTimeZone dateTime) throws Exception {
    return dateTime == null ? null : dateTime.getID();
  }

}