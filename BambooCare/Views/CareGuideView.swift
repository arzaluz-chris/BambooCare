//
//  CareGuideView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI

struct CareGuideView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bambooLight.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Sección 1: Problemas Comunes
                        GuideSection(
                            title: "Problemas Comunes",
                            icon: "exclamationmark.triangle.fill",
                            items: commonProblems
                        )

                        // Sección 2: Plagas y Enfermedades
                        GuideSection(
                            title: "Plagas y Enfermedades",
                            icon: "ant.fill",
                            items: pestsAndDiseases
                        )

                        // Sección 3: Consejos Generales
                        GuideSection(
                            title: "Consejos Generales",
                            icon: "lightbulb.fill",
                            items: generalTips
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Guía de Cuidados")
            .searchable(text: $searchText, prompt: "Buscar en la guía")
        }
    }
}

// MARK: - Guide Section

struct GuideSection: View {
    let title: String
    let icon: String
    let items: [GuideItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.bambooPrimary)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.bottom, 8)

            ForEach(items) { item in
                NavigationLink {
                    GuideDetailView(item: item)
                } label: {
                    GuideItemRow(item: item)
                }
            }
        }
        .padding()
        .bambooCard()
    }
}

struct GuideItemRow: View {
    let item: GuideItem

    var body: some View {
        HStack {
            Image(systemName: item.icon)
                .foregroundColor(.bambooPrimary)
                .frame(width: 30)

            Text(item.title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Guide Detail View

struct GuideDetailView: View {
    let item: GuideItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: item.icon)
                        .font(.largeTitle)
                        .foregroundColor(.bambooPrimary)

                    Text(item.title)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding()

                // Descripción
                if let description = item.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descripción")
                            .font(.headline)
                            .foregroundColor(.bambooPrimary)

                        Text(description)
                            .font(.body)
                    }
                    .padding()
                    .bambooCard()
                }

                // Causas
                if let causes = item.causes, !causes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Causas Posibles")
                            .font(.headline)
                            .foregroundColor(.bambooPrimary)

                        ForEach(causes, id: \.self) { cause in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                Text(cause)
                            }
                        }
                    }
                    .padding()
                    .bambooCard()
                }

                // Soluciones
                if let solutions = item.solutions, !solutions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Soluciones")
                            .font(.headline)
                            .foregroundColor(.bambooPrimary)

                        ForEach(solutions, id: \.self) { solution in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(solution)
                            }
                        }
                    }
                    .padding()
                    .bambooCard()
                }

                // Prevención
                if let prevention = item.prevention {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prevención")
                            .font(.headline)
                            .foregroundColor(.bambooPrimary)

                        Text(prevention)
                            .font(.body)
                    }
                    .padding()
                    .bambooCard()
                }
            }
            .padding()
        }
        .background(Color.bambooLight)
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Guide Item Model

struct GuideItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let description: String?
    let causes: [String]?
    let solutions: [String]?
    let prevention: String?
}

// MARK: - Guide Data

let commonProblems: [GuideItem] = [
    GuideItem(
        title: "Hojas Amarillas",
        icon: "leaf",
        description: "Las hojas amarillas son uno de los problemas más comunes en el bambú.",
        causes: [
            "Exceso de riego",
            "Falta de nutrientes",
            "Luz solar insuficiente",
            "Agua con exceso de cloro o flúor"
        ],
        solutions: [
            "Reduce la frecuencia de riego",
            "Fertiliza con un fertilizante balanceado cada 2-3 meses",
            "Mueve la planta a un lugar con más luz",
            "Usa agua filtrada o déjala reposar 24 horas antes de regar"
        ],
        prevention: "Mantén un programa de riego consistente y asegúrate de que la planta reciba suficiente luz indirecta."
    ),
    GuideItem(
        title: "Manchas Marrones",
        icon: "circlebadge.fill",
        description: "Las manchas marrones pueden indicar varios problemas.",
        causes: [
            "Quemaduras por sol directo",
            "Riego insuficiente",
            "Hongos o bacterias",
            "Daño por frío"
        ],
        solutions: [
            "Aleja la planta de la luz solar directa",
            "Aumenta la frecuencia de riego gradualmente",
            "Retira hojas afectadas y aplica fungicida si es necesario",
            "Protege del frío, mantén temperatura sobre 10°C"
        ],
        prevention: "Evita cambios bruscos de temperatura y ubicación. Mantén un ambiente estable."
    ),
    GuideItem(
        title: "Crecimiento Lento",
        icon: "arrow.down.circle",
        description: "El bambú normalmente crece rápido. Un crecimiento lento puede indicar problemas.",
        causes: [
            "Falta de nutrientes",
            "Maceta demasiado pequeña",
            "Luz insuficiente",
            "Temperatura inadecuada"
        ],
        solutions: [
            "Fertiliza regularmente durante la temporada de crecimiento",
            "Trasplanta a una maceta más grande",
            "Proporciona más luz natural indirecta",
            "Mantén temperatura entre 15-25°C"
        ],
        prevention: "Proporciona las condiciones ideales: luz adecuada, nutrientes y espacio suficiente."
    ),
    GuideItem(
        title: "Hojas Secas y Rizadas",
        icon: "flame",
        description: "Las hojas secas y rizadas generalmente indican estrés hídrico.",
        causes: [
            "Falta de agua",
            "Humedad ambiental muy baja",
            "Exposición a corrientes de aire",
            "Calor excesivo"
        ],
        solutions: [
            "Aumenta la frecuencia de riego",
            "Rocía las hojas con agua regularmente",
            "Aleja de ventiladores, aires acondicionados o calefacción",
            "Usa un humidificador o bandeja con agua y piedras"
        ],
        prevention: "Mantén un nivel de humedad adecuado y evita cambios bruscos de temperatura."
    )
]

let pestsAndDiseases: [GuideItem] = [
    GuideItem(
        title: "Ácaros",
        icon: "ant.circle",
        description: "Los ácaros son plagas comunes que se alimentan de la savia de las plantas.",
        causes: [
            "Ambiente seco",
            "Falta de ventilación",
            "Plantas cercanas infectadas"
        ],
        solutions: [
            "Rocía con agua jabonosa (jabón neutro)",
            "Aplica aceite de neem",
            "Aumenta la humedad ambiental",
            "Aísla la planta afectada"
        ],
        prevention: "Mantén buena humedad y ventilación. Inspecciona regularmente las plantas."
    ),
    GuideItem(
        title: "Cochinillas",
        icon: "ladybug",
        description: "Pequeños insectos que forman colonias blancas y pegajosas.",
        causes: [
            "Plantas nuevas infectadas",
            "Condiciones de estrés",
            "Exceso de nitrógeno"
        ],
        solutions: [
            "Retira manualmente con algodón y alcohol",
            "Aplica jabón insecticida",
            "Usa aceite de neem",
            "Introduce mariquitas (control biológico)"
        ],
        prevention: "Inspecciona plantas nuevas antes de introducirlas. Evita fertilización excesiva."
    ),
    GuideItem(
        title: "Hongos",
        icon: "cloud.rain",
        description: "Manchas negras, moho o pudrición causados por hongos.",
        causes: [
            "Exceso de humedad",
            "Mala ventilación",
            "Agua estancada",
            "Hojas mojadas por la noche"
        ],
        solutions: [
            "Retira partes afectadas",
            "Mejora la ventilación",
            "Reduce el riego",
            "Aplica fungicida apropiado",
            "Riega por la mañana"
        ],
        prevention: "Evita mojar las hojas, asegura buen drenaje y ventilación adecuada."
    )
]

let generalTips: [GuideItem] = [
    GuideItem(
        title: "Fertilización",
        icon: "leaf.circle",
        description: "La fertilización adecuada es clave para un bambú saludable.",
        causes: nil,
        solutions: [
            "Fertiliza cada 2-3 meses durante primavera y verano",
            "Usa fertilizante balanceado (NPK 20-20-20) o específico para bambú",
            "Diluye a la mitad de la concentración recomendada",
            "No fertilices en invierno (período de reposo)",
            "Para bambú de la suerte en agua, fertiliza mensualmente con muy poca cantidad"
        ],
        prevention: "No sobre-fertilices, esto puede quemar las raíces y dañar la planta."
    ),
    GuideItem(
        title: "Poda y Mantenimiento",
        icon: "scissors",
        description: "La poda ayuda a mantener la forma y salud del bambú.",
        causes: nil,
        solutions: [
            "Retira hojas amarillas o secas regularmente",
            "Corta cañas viejas o dañadas desde la base",
            "Controla el tamaño cortando las cañas a la altura deseada",
            "Limpia las hojas con un paño húmedo para remover polvo",
            "La mejor época para podar es primavera"
        ],
        prevention: "Usa herramientas limpias y afiladas para evitar infecciones."
    ),
    GuideItem(
        title: "Sustrato y Macetas",
        icon: "cylinder",
        description: "El sustrato y contenedor correctos son fundamentales.",
        causes: nil,
        solutions: [
            "Usa sustrato rico en materia orgánica y bien drenado",
            "Mezcla: 60% tierra para macetas, 20% perlita, 20% compost",
            "Asegura que la maceta tenga agujeros de drenaje",
            "Trasplanta cada 2-3 años o cuando las raíces llenen el contenedor",
            "Elige macetas de tamaño adecuado (no demasiado grandes)"
        ],
        prevention: "Nunca uses tierra de jardín pura, puede compactarse y ahogar las raíces."
    ),
    GuideItem(
        title: "Riego del Bambú de la Suerte en Agua",
        icon: "drop",
        description: "Consejos específicos para bambú de la suerte en jarrón.",
        causes: nil,
        solutions: [
            "Cambia el agua completamente cada 7-10 días",
            "Usa agua filtrada o de lluvia (sin cloro)",
            "Mantén nivel de agua cubriendo las raíces",
            "Limpia el jarrón y raíces al cambiar el agua",
            "Añade fertilizante líquido muy diluido mensualmente"
        ],
        prevention: "Agua turbia o maloliente indica cambio urgente. Mantén el agua limpia y fresca."
    ),
    GuideItem(
        title: "Propagación",
        icon: "arrow.triangle.branch",
        description: "Cómo multiplicar tus plantas de bambú.",
        causes: nil,
        solutions: [
            "Corta una caña sana con al menos un nodo",
            "Coloca en agua limpia hasta que desarrolle raíces (2-4 semanas)",
            "Cambia el agua cada 3-4 días",
            "Una vez con raíces, planta en tierra o deja en agua",
            "También puedes dividir plantas establecidas al trasplantar"
        ],
        prevention: "La mejor época para propagar es primavera o principios de verano."
    ),
    GuideItem(
        title: "Señales de Buena Salud",
        icon: "checkmark.seal.fill",
        description: "Cómo saber que tu bambú está saludable.",
        causes: nil,
        solutions: [
            "Hojas verdes brillantes y firmes",
            "Nuevo crecimiento regular durante la temporada",
            "Cañas firmes y de color uniforme",
            "Raíces blancas o claras (no marrones ni blandas)",
            "Sin manchas, plagas o decoloración"
        ],
        prevention: "La observación regular es la mejor herramienta de prevención."
    )
]

#Preview {
    CareGuideView()
}
