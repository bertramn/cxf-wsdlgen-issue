package some.model;


import javax.xml.bind.annotation.*;
import java.io.Serializable;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SomeDomainEntity", propOrder = {
  "name",
})
public class SomeDomainEntity implements Serializable {

  private final static long serialVersionUID = 20170310L;

  @XmlAttribute(name = "id", required = true)
  protected String id;

  @XmlElement(name = "Name", required = true)
  protected String name;

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

}
