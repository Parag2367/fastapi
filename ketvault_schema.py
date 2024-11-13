class create_kv(BaseModel):
    kv_name: Optional[str] = None
    requestor_aa_id :int
    rg_name: str
    aa_location: str
    storage_sku: storage_sku_enum