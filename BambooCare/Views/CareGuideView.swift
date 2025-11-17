//
//  CareGuideView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI

struct CareGuideView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.bambooBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        GuideSection(
                            title: "Problemas Comunes",
                            icon: "exclamationmark.triangle.fill",
                            items: [
                                GuideItem(title: "Hojas Amarillas", description: "Causas: exceso de agua, falta de nutrientes o luz insuficiente. Solución: revisa el riego y considera fertilizar.", icon: "leaf"),
                                GuideItem(title: "Manchas Marrones", description: "Puede indicar riego insuficiente, quemaduras solares o plagas. Verifica la humedad del suelo.", icon: "leaf"),
                                GuideItem(title: "Crecimiento Lento", description: "Asegúrate de proporcionar luz adecuada y fertiliza durante la temporada de crecimiento.", icon: "arrow.down.circle")
                            ]
                        )

                        GuideSection(
                            title: "Plagas y Enfermedades",
                            icon: "ant.fill",
                            items: [
                                GuideItem(title: "Ácaros", description: "Pequeños insectos que causan decoloración. Tratamiento: jabón insecticida o aceite de neem.", icon: "ladybug"),
                                GuideItem(title: "Cochinillas", description: "Insectos blancos algodonosos. Retíralos manualmente y aplica alcohol isopropílico.", icon: "circle.grid.cross"),
                                GuideItem(title: "Hongos", description: "Manchas oscuras o moho. Mejora la circulación de aire y reduce el riego.", icon: "cloud.fill")
                            ]
                        )

                        GuideSection(
                            title: "Consejos Generales",
                            icon: "lightbulb.fill",
                            items: [
                                GuideItem(title: "Fertilización", description: "Fertiliza mensualmente durante primavera y verano con fertilizante balanceado.", icon: "sparkles"),
                                GuideItem(title: "Poda", description: "Elimina hojas muertas o amarillas regularmente para mantener la salud.", icon: "scissors"),
                                GuideItem(title: "Sustrato", description: "Usa tierra bien drenada. Para bambú en agua, cambia el agua semanalmente.", icon: "drop.triangle")
                            ]
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Guía de Cuidados")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct GuideSection: View {
    let title: String
    let icon: String
    let items: [GuideItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.bambooPrimary)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)
            }
            .padding(.bottom, 4)

            ForEach(items) { item in
                GuideItemRow(item: item)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct GuideItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
}

struct GuideItemRow: View {
    let item: GuideItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: item.icon)
                .foregroundStyle(.bambooPrimary)
                .font(.title3)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.textPrimary)

                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    CareGuideView()
}
