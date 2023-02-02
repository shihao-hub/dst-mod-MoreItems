---
--- @author zsh in 2023/1/9 2:19
---


local minimap = {
    "minimap/ndnr_armorvortexcloak.xml",
    "minimap/mone_piggybag.xml",
    "minimap/garlic_bat.xml",
    "minimap/mone_wathgrithr_box.xml",
    "minimap/mone_wanda_box.xml",

    -- ������̫�ã�֮����prefabs��ֱ����Asset("MINIMAP_IMAGE","picture_name")���������ͼƬ�ǵõ��룡
    "images/inventoryimages.xml",
    "images/inventoryimages2.xml",
    -- DLC0002
    "images/DLC0002/inventoryimages.xml",
    -- DLC0003
    "images/DLC0003/inventoryimages.xml"
}

for _, v in ipairs(minimap) do
    AddMinimapAtlas(v);
    table.insert(Assets, Asset("ATLAS", v));
end