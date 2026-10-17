#include <QApplication>
#include <QPalette>
#include <QColor>
#include <QWidget>
#include <KColorScheme>
#include <KSharedConfig>
#include <dlfcn.h>
#include <cstdio>

typedef void (*QAppCtor)(QApplication*, int&, char**, int);
typedef QColor (*OrigTextColor)(const void*, const QWidget&);

extern "C" {

void _ZN12QApplicationC1ERiPPci(QApplication* this_ptr, int& argc, char** argv, int flags) {
    static QAppCtor orig = (QAppCtor)dlsym(RTLD_NEXT, "_ZN12QApplicationC1ERiPPci");
    if (orig) {
        orig(this_ptr, argc, argv, flags);
    }
    
    // Load palette from kdeglobals
    auto config = KSharedConfig::openConfig();
    QPalette pal = KColorScheme::createApplicationPalette(config);
    // Explicitly set Text and WindowText to bright readable color
    pal.setColor(QPalette::Active, QPalette::Text, QColor(205, 214, 244));
    pal.setColor(QPalette::Inactive, QPalette::Text, QColor(205, 214, 244));
    pal.setColor(QPalette::Active, QPalette::WindowText, QColor(205, 214, 244));
    pal.setColor(QPalette::Inactive, QPalette::WindowText, QColor(166, 173, 200));
    pal.setColor(QPalette::Active, QPalette::Base, QColor(30, 30, 46));
    pal.setColor(QPalette::Inactive, QPalette::Base, QColor(30, 30, 46));
    QApplication::setPalette(pal);
}

// Hook KStandardItemListWidget::textColor(const QWidget &) const
QColor _ZNK23KStandardItemListWidget9textColorERK7QWidget(const void* this_ptr, const QWidget& widget) {
    static OrigTextColor orig = (OrigTextColor)dlsym(RTLD_NEXT, "_ZNK23KStandardItemListWidget9textColorERK7QWidget");
    QColor c = orig ? orig(this_ptr, widget) : QColor(205, 214, 244);
    
    // If the computed color is dark (lightness < 150), force it to readable Catppuccin text!
    if (c.lightness() < 150) {
        return QColor(205, 214, 244); // #cdd6f4 Catppuccin Mocha Text
    }
    return c;
}

}
