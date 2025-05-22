// a set of tools used to manages list (planets, particles and so on) //<>// //<>//

class DataList extends GenericData
{
  int current_index = 0;
  ArrayList<GenericData> items = new ArrayList<GenericData>();
  String sub_chapter_name = "";


  DataList(String chapter_name, String sub_chapter_name)
  {
    super(chapter_name);
    this.sub_chapter_name = sub_chapter_name;
  }

  int count()
  {
    return items.size();
  }
  
  void reset()
  {
    items.clear();
    current_index = 0;
  }

  // must be overriden by real implementation
  GenericData newItem()
  {
    return null;
  }

  public void LoadJson(JSONObject json) {
    if (json == null) return;

    int nb_items = json.getInt("nb_items", 0);
    current_index = json.getInt("current_index", 0);
    for (int i = 0; i < nb_items; i++)
    {
      GenericData item = newItem();
      item.LoadJson(json.getJSONObject(sub_chapter_name + "_" + i));
      items.add(item);
    }
  }

  public JSONObject SaveJson() {
    JSONObject json = new JSONObject();

    int nb_items = items.size();
    json.setInt("nb_items", nb_items);

    for (int i = 0; i < nb_items; i++)
    {
      GenericData item = items.get(i);
      json.setJSONObject(sub_chapter_name + "_"+i, item.SaveJson());
    }

    json.setInt("current_index", current_index);

    return json;
  }
}

class GUIListPanel extends GUIPanel
{
  DataList data_list;


  GUIListPanel(String pageName, DataList data)
  {
    super(pageName, data);
    this.data_list = data;
  }

  void updateCurrentItem()
  {
    // update content of the current item
  }

  void addListBar()
  {
    space();
    addButton("Prev").plugTo(this, "prev");
    addButton("Remove").plugTo(this, "remove");
    addButton("Add").plugTo(this, "add");
    addButton("Next").plugTo(this, "next");
    nextLine();
    space();
  }

  void prev()
  {
    if (data_list.count() == 0)
    {
      data_list.current_index = 0;
    } else
    {
      data_list.current_index = data_list.current_index -1;
      if (data_list.current_index < 0)
        data_list.current_index = data_list.count() -1;
    }

    updateCurrentItem();
  }

  void next()
  {
    if (data_list.count() == 0)
    {
      data_list.current_index = 0;
    } else
    {
      data_list.current_index = data_list.current_index + 1;
      if (data_list.current_index >= data_list.count())
        data_list.current_index = 0;
    }

    updateCurrentItem();
  }

  void fix_index()
  {
    if (data_list.current_index >= data_list.count())
      data_list.current_index = data_list.count() -1;

    else if (data_list.current_index < 0)
      data_list.current_index = 0;
  }

  void add()
  {
    data_list.items.add(data_list.newItem());
    data_list.current_index = data_list.items.size() -1;

    updateCurrentItem();
  }

  void remove()
  {
    if (data_list.count() == 0)
      return;

    fix_index();

    data_list.items.remove(data_list.current_index);
    data_list.current_index--;
    fix_index();  
    updateCurrentItem();
  }
}
