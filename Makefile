include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-seu-net
PKG_VERSION:=v10
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  DEPENDS:=+curl
  TITLE:=LuCI support for seu network login and logout
  PKGARCH:=all
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/seu-net
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/usr/bin/seu-net $(1)/etc/config $(1)/usr/lib/lua/luci $(1)/etc/uci-defaults
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_CONF) ./root/etc/config/seu-net $(1)/etc/config
	$(INSTALL_BIN) ./root/etc/init.d/seu-net $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/uci-defaults/luci-seu-net $(1)/etc/uci-defaults/luci-seu-net
	$(INSTALL_BIN) ./root/usr/bin/seu-net/seu-net $(1)/usr/bin/seu-net
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
