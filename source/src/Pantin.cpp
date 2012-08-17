/*
 * 	Copyright (c) 2010-2011, Romuald CARI
 *	All rights reserved.
 *
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *		* Redistributions of source code must retain the above copyright
 *		  notice, this list of conditions and the following disclaimer.
 *		* Redistributions in binary form must reproduce the above copyright
 *		  notice, this list of conditions and the following disclaimer in the
 *		  documentation and/or other materials provided with the distribution.
 *		* Neither the name of the <organization> nor the
 *		  names of its contributors may be used to endorse or promote products
 *		  derived from this software without specific prior written permission.
 *
 *	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Pantin.cpp
 *
 *  Created on: 17 juil. 2009
 *      Author: Romuald
 */

#include <Pantin.hpp>

#include <KoreApplication.hpp>
using namespace Kore;

#include <NigelApplication.hpp>
using namespace Nigel;

#include <GLrApplication.hpp>
using namespace GLr;

#include <PantinApplication.hpp>
using namespace Pantin;

#include <GooeyApplication.hpp>
#ifdef _K_MACX
#include <common/GooeyStyle.hpp>
#endif
using namespace Gooey;

#include <QtCore/QDateTime>
#include <QtCore/QtDebug>

#include <QtGui/QApplication>
#include <QtGui/QSplashScreen>

#include <QtGui/QPlastiqueStyle>

int main(int argc, char** argv)
{
	QApplication app(argc, argv);

	QCoreApplication::setOrganizationName("pixelfr0g");
	QCoreApplication::setOrganizationDomain("pixelfr0g.com");
	QCoreApplication::setApplicationName("Pantin Studio");
	QCoreApplication::setApplicationVersion(_PANTIN_STUDIO_VERSION);

	qDebug("------------------------------------------------------------");
	qDebug() << " Pantin-Studio / Starting up on" << QDateTime::currentDateTime().toString();
	qDebug("------------------------------------------------------------");

#ifdef _K_MACX
	QApplication::setStyle(new common::GooeyStyle());
#else
	QApplication::setStyle(new QPlastiqueStyle());
#endif

	QSplashScreen splash(QPixmap(":/pantin-studio/images/splash.png"));
	splash.setVisible(true);
	splash.raise();

	app.processEvents();

	splash.showMessage("Loading Kore...", Qt::AlignLeft | Qt::AlignBottom);
	KoreApplication kore(argc, argv);
	splash.showMessage("Loading Kore... OK", Qt::AlignLeft | Qt::AlignBottom);

	app.processEvents();

	splash.showMessage("Loading Nigel...", Qt::AlignLeft | Qt::AlignBottom);
	NigelApplication nigel(argc, argv);
	splash.showMessage("Loading Nigel... OK", Qt::AlignLeft | Qt::AlignBottom);

	app.processEvents();

	splash.showMessage("Loading GLr...", Qt::AlignLeft | Qt::AlignBottom);
	GLrApplication glr(argc, argv);
	splash.showMessage("Loading GLr... OK", Qt::AlignLeft | Qt::AlignBottom);

	app.processEvents();

	splash.showMessage("Loading Gooey...", Qt::AlignLeft | Qt::AlignBottom);
	GooeyApplication gooey(argc, argv);
	splash.showMessage("Loading Gooey... OK", Qt::AlignLeft | Qt::AlignBottom);

	app.processEvents();

	splash.showMessage("Loading Pantin...", Qt::AlignLeft | Qt::AlignBottom);
	PantinApplication pantin(splash);
	splash.showMessage("Loading Pantin... OK", Qt::AlignLeft | Qt::AlignBottom);

	qDebug() << "Pantin-Studio /" << "Showtime !";

	int result = app.exec();

	// Purge events !
	app.processEvents();

	return result;
}
