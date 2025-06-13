import numpy as np
import matplotlib.pyplot as plt
import skrf as rf


## Lectura archivos
network1 = rf.Network('111111.s1p') # Antena gruesa
network2 = rf.Network('22222.s1p') # Antena fina


## Datos S11 y Z
# Para antena gruesa:
s11_mag_db1 = network1.s_db[:, 0, 0]
s11_phase1 = network1.s_deg[:, 0, 0]
frequencies_ghz1 = network1.f / 1e9
s11_complex1 = network1.s[:, 0, 0]

z11_complex1 = network1.z[:, 0, 0]
z11_real1 = z11_complex1.real
z11_imag1 = z11_complex1.imag

# Para antena fina:
s11_mag_db2 = network2.s_db[:, 0, 0]
s11_phase2 = network2.s_deg[:, 0, 0]
frequencies_ghz2 = network2.f / 1e9
s11_complex2 = network2.s[:, 0, 0]

z11_complex2 = network2.z[:, 0, 0] 
z11_real2 = z11_complex2.real
z11_imag2 = z11_complex2.imag

## Plot S11 antena gruesa
fig, ax1 = plt.subplots(figsize=(8, 5))

ax1.plot(frequencies_ghz1, s11_mag_db1, label=f'$|S_{{11}}|$ (dB)', color='tan')
ax1.axhline(y=-10, color='red', linestyle='--', label='Umbral $|S_{11}|$ = -10 dB (VSWR ≈ 2:1)')
ax1.set_xlabel('Frecuencia (GHz)')
ax1.set_ylabel('$|S_{11}|$ (dB)', color='black')
ax1.tick_params(axis='y', labelcolor='black')
ax1.set_ylim(-27, 1)
ax1.set_xlim(0, 8.5)
ax1.grid(True)

ax2 = ax1.twinx()
ax2.plot(frequencies_ghz1, s11_phase1, label=f'Fase de $S_{{11}}$ (Deg)', color='red', linestyle=':')
ax2.set_ylabel('Fase de $S_{11}$ (Grados)', color='red')
ax2.tick_params(axis='y', labelcolor='red')

lines, labels = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax2.legend(lines + lines2, labels + labels2, loc='lower right')
plt.title(f'Magnitud y Fase de $S_{{11}}$ vs. Frecuencia para la antena de borde grueso')
plt.tight_layout()
plt.show()

## Plot S11 antena fina
fig, ax1 = plt.subplots(figsize=(8, 5))

ax1.plot(frequencies_ghz2, s11_mag_db2, label=f'$|S_{{11}}|$ (dB)', color='olive')
ax1.axhline(y=-10, color='red', linestyle='--', label='Umbral $|S_{11}|$ = -10 dB (VSWR ≈ 2:1)')
ax1.set_xlabel('Frecuencia (GHz)')
ax1.set_ylabel('$|S_{11}|$ (dB)', color='black')
ax1.tick_params(axis='y', labelcolor='black')
ax1.set_ylim(-27, 1)
ax1.set_xlim(0, 8.5)
ax1.grid(True)

ax2 = ax1.twinx()
ax2.plot(frequencies_ghz2, s11_phase2, label=f'Fase de $S_{{11}}$ (Deg)', color='darkblue', linestyle=':')
ax2.set_ylabel('Fase de $S_{11}$ (Grados)', color='blue')
ax2.tick_params(axis='y', labelcolor='blue')

lines, labels = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax2.legend(lines + lines2, labels + labels2, loc='lower right')
plt.title(f'Magnitud y Fase de $S_{{11}}$ vs. Frecuencia para la antena de borde fino')
plt.tight_layout()
plt.show()

## Z para antena gruesa
plt.figure(figsize=(8, 5))
plt.plot(frequencies_ghz1, z11_real1, label=f'Parte real de $Z$ - Borde grueso', color='darkorange')
plt.plot(frequencies_ghz1, z11_imag1, label=f'Parte imaginaria de $Z$ - Borde grueso', color='darkcyan', linestyle='--')
plt.title(f'Partes Real e Imaginaria de $Z$ para la antena de borde grueso')
plt.xlabel('Frecuencia (GHz)')
plt.ylabel('Impedancia ($\Omega$)')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()

## Z para antena fina
plt.figure(figsize=(8, 5))
plt.plot(frequencies_ghz2, z11_real2, label=f'Parte real de $Z$ - Borde fino', color='brown')
plt.plot(frequencies_ghz2, z11_imag2, label=f'Parte imaginaria de $Z$ - Borde fino', color='darkmagenta', linestyle='--')
plt.title(f'Partes Real e Imaginaria de $Z$ para la antena de borde fino')
plt.xlabel('Frecuencia (GHz)')
plt.ylabel('Impedancia ($\Omega$)')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
