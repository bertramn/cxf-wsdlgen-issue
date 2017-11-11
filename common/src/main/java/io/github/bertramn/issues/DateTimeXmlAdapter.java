package io.github.bertramn.issues;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class DateTimeXmlAdapter extends XmlAdapter<String, DateTime> {

  DateTimeFormatter fmt = ISODateTimeFormat.dateTime();

  @Override
  public DateTime unmarshal(String dateTime) throws Exception {
    return dateTime == null ? null : DateTime.parse(dateTime);
  }

  @Override
  public String marshal(DateTime dateTime) throws Exception {
    return dateTime == null ? null : dateTime.toString(fmt);
  }

}